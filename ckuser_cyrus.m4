divert(-1)
# Written by Mike Boev <mike@tric.ru>, 2004.
# Homepage: http://tric.ru/users/mike/ckuser_cyrus/
# Inspired by: mrs_cyrus.m4 by Andrzej Adam Filip
#
# By using this file, you agree to the terms and conditions set
# forth in the LICENSE file which can be found at the top level of
# the sendmail distribution.
#
divert(0)
VERSIONID(`$Id: ckuser_cyrus.m4,v 1.4 2004/09/21 19:02:17 m Exp $')
divert(-1)
define(`CYRUS_SMMAPD_SOCKET',
        ifelse(len(X`'_ARG_), `1', `local:/var/imap/socket/smmapd', _ARG_))

MODIFY_MAILER_FLAGS(`CYRUSV2',`+5')

LOCAL_CONFIG
# Cyrus smmapd(8)'s map for verifying mailboxes of local recipients
Kcyrus socket -a<OK> -T<TMPF> CYRUS_SMMAPD_SOCKET

LOCAL_RULESETS
SLocal_localaddr
R$+			$: $> "ckuser_cyrus" $1

Sckuser_cyrus
#Query smmapd(8)
R$+			$: <!> $1 $| $(cyrus $1 $: $)
#Cyrus OK, skip
R<!> $* $| $* <OK>	$@ $1					
#Over quota or lookup failure
R<!> $* $| $* <TMPF>	$# error $@ 4.3.0 $: "451 TEMPFAIL."	
#Mailbox doesn't exist or its ACL forbids posting
R<!> $* $| $*		$# error $@ 5.1.1 $: "550 Mailbox is not available."
