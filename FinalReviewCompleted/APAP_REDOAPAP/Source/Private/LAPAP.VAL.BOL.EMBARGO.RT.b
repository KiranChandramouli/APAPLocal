* @ValidationCode : MjoxMTY2NzY3NTcxOkNwMTI1MjoxNjg1MDE1MjMyMzE2OnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 May 2023 17:17:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED,FM TO @FM,i TO i.VAR
*25-05-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.VAL.BOL.EMBARGO.RT

    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.VERSION
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.APAP.H.GARNISH.DETAILS ;*R22 AUTO CONVERSION END


    GOSUB LOAD
    GOSUB PROCESS
*====
LOAD:
*====

    Y.CED.ID                 = R.NEW(APAP.GAR.IDENTITY.NUMBER)
    Y.PARAMETER              = "BOLSILLO"

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

*=======
PROCESS:
*=======

    CUS.REC = ''; CUS.ERR = ''; Y.COUNT.CUS = ''; CUS.POS = '';
    SEL.CMD = "SELECT ":FN.CUSTOMER:" WITH L.CU.CIDENT EQ " :Y.CED.ID:" OR L.CU.RNC EQ ":Y.CED.ID:" OR L.CU.PASS.NAT EQ ":Y.CED.ID""
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", CUS.REC, CUS.ERR);

    Y.CUSTOMER.ID              = SEL.LIST
    R.CUSTOMER = ''; CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,FN.CUSTOMER,CUSTOMER.ERR)
    Y.CUS.NAME                 = R.CUSTOMER<EB.CUS.SHORT.NAME>

    R.CUSTOMER.ACC = ''; CUSTOMER.ACC.ERR = ''
    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUSTOMER.ID,R.CUSTOMER.ACC,F.CUSTOMER.ACCOUNT,CUSTOMER.ACC.ERR)

    Y.ACC.NUM                = R.CUSTOMER.ACC
    Y.ACC.NUM.COUNT          = DCOUNT(Y.ACC.NUM,@FM) ;*R22 AUTO CONVERSION

    i.VAR = 0; ;*R22 AUTO CONVERSION START
    FOR i.VAR = 1 TO Y.ACC.NUM.COUNT
        CRT Y.ACC.NUM<i.VAR>
        Y.ACCOUNT           = Y.ACC.NUM<i.VAR> ;*R22 AUTO CONVERSION END

        NO.OF.REC = ''; SEL.ERR = ''; Y.COUNT.LIST = ''; LIST.POS = '';
        SEL.CMD = "SELECT ":FN.AC.LOCKED.EVENTS:" WITH ACCOUNT.NUMBER EQ " :Y.ACCOUNT:" AND L.AC.LOCKE.TYPE EQ " :Y.PARAMETER;
        CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);
        Y.COUNT.LOCK = DCOUNT(SEL.LIST,@FM); ;*R22 AUTO CONVERSION

        IF Y.COUNT.LOCK GT 0 THEN
            TEXT = "El cliente: ":Y.CUS.NAME:" tiene bolsillos asociados, por favor eliminar antes de proceder con el embargo"
            ETEXT = TEXT
            E = TEXT
            CALL ERR
        END
    NEXT i.VAR ;*R22 AUTO CONVERSION
RETURN
END
