* @ValidationCode : MjotMTg0MTEwODQ2NDpDcDEyNTI6MTY4MjQxMjM2NjMzNzpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VALIDATE.SETTLE.ACC

*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This is a validation routine to validate the settlement account and deposit account
* ACCOUNT.CLOSURE,REDO.EN.LINEA
*
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date        who               Reference       Description
*27-7-15        Maheswaran j    PACS00462895    Validate the  accounts
*Modification history
*Date                Who               Reference                  Description
*20-04-2023      conversion tool     R22 Auto code conversion     No changes
*20-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*----
    Y.APPL = 'ACCOUNT.CLOSURE'
    Y.FIELDS = 'L.AC.AZ.ACC.REF'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL, Y.FIELDS, Y.POS)
    Y.ACC.POSS = Y.POS<1,1>
RETURN

PROCESS:
*-------
    Y.SETLLE.AC = COMI
    Y.ACC = R.NEW(AC.ACL.LOCAL.REF)<1,Y.ACC.POSS>
    IF Y.SETLLE.AC EQ Y.ACC THEN
        AF =  AC.ACL.SETTLEMENT.ACCT
        ETEXT = 'EB-CHK.AC.SETTLE.ACC'
        CALL STORE.END.ERROR
    END
RETURN

END
