#!/usr/bin/perl -w

# (C) 2004-12-10 Thomas Radke <tradke@aei.mpg.de>
# Some changes by Erik Schnetter <schnetter@aei.mpg.de>
# Majorly changed for Thousand Parsec by Lee Begg <llnz@paradise.net.nz>
# Changed to use hash's instead of names by Tim Ansell <tim@thousandparsec.net>
# GPL licenced

### some constants
# list of email addresses to send notifications to
my $email_list = 'tp-cvs@thousandparsec.net';
# where to find the real darcs executable
my $darcs = '/usr/bin/darcs';

# sanity check
die "Couldn't find executable '$darcs'!\n\n" if (! -x $darcs);

#set permissions correctly.
system("find . -user \"\$USER\" -a ! -perm +g+w -exec chmod g+w '{}' ';'");

# Get the last patch we sent out details about.
my $lastpn = "";
if (open (PFILE, "/var/lib/darcs/cache/email-new/$ARGV[0]")) {
	my @pncont = <PFILE>;
	close (PFILE) || die "Failed to close patchname file'\n";
	$lastpn = $pncont[0];
	chomp($lastpn);
}

# Find the last 32 changes
open (DARCS, "$darcs changes --last 32 --xml |") || die "Couldn't open pipe to darcs !\n";
my @pcontents = <DARCS>;
close (DARCS) || die "Failed to run darcs command '$darcs changes --last 32 --xml'\n";

my $firsttime = 1;
foreach(@pcontents){
	if (m/^.*hash='(.*\.gz)'.*$/) {
		my $hash = $1;

		# Write out the last patch to have an email sent for.
		if($firsttime == 1) {
		    open (PFILE, ">/var/lib/darcs/cache/email-new/$ARGV[0]") || die "Couldn't open patchname file!\n";
		    print PFILE "$hash\n";
		    close (PFILE) || die "Failed to close patchname file'\n";
		    chmod 0664, "/var/lib/darcs/cache/email-new/$ARGV[0]";
		    $firsttime = 0;
		}

		if($hash eq $lastpn) {
		    last;
		}

		# open a pipe for running darcs on the other end
		open (DARCS, "$darcs diff --match \"hash $hash\" -u |") || die "Couldn't open pipe to darcs !\n";
		my @contents = <DARCS>;
		close (DARCS) || die "Failed to run darcs command '$darcs diff --match \"hash $hash\" -u'\n";

		$contents[1] =~ m/^\s*\*\s*(.*)$/;
		my $patchname = $1;
		chomp($patchname);

		# now send out notification email(s)
		# Not safe, because the shell expands meta-characters:
		#open (NOTIFY, "| mail -s '$patch' $email_list");
		# More elegant, but only in Perl 5.8 and later:
		#open (NOTIFY, '|-', 'mail', '-s', $patch, $email_list);
		# Safe, I think:
		#open (NOTIFY, '|-') || exec 'mail', '-s', $patch, $email_list;
		# Use sendmail instead
		open (NOTIFY, '|-') || exec '/usr/sbin/sendmail', '-oi', '-t', '-f', "$ENV{USER}\@thousandparsec.net";

		print NOTIFY "MIME-Version: 1.0\n";
		print NOTIFY "From: $ENV{USER}\@thousandparsec.net\n";
		print NOTIFY "To: $email_list\n";
		print NOTIFY "Subject: $ARGV[0] - $patchname\n";
		print NOTIFY "X-Mailer: darcs_tp_mail-n-stats.pl\n";
		print NOTIFY "Content-Type: text/plain\n\n";

		print NOTIFY "A new patch has been pushed into the Thousand Parsec repository for $ARGV[0]:\n\n";
		foreach(@contents){
			print NOTIFY $_;
		}

		close (NOTIFY);
	}
}

