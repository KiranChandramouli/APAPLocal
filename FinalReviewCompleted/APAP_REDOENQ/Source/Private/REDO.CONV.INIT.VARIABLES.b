$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.INIT.VARIABLES
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : GANESH H
* Program Name : REDO.CONV.INIT.VARIABLES
*-----------------------------------------------------------------------------
* Description :This is a auto new content routine for FT/STO version
* Linked with :
* In Parameter :
* Out Parameter :
*DATE           ODR                   DEVELOPER               VERSION
*07.04.2011     PACS00036498           GANESH H            INITIAL CREATION
*25.08.2011     PACS00104449          Balagurunathan          Modify as per issue
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM , SM to @SM ,FM to @FM and Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_S.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.USER
    $INSERT I_F.USER.SIGN.ON.NAME
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.H.SOLICITUD.CK
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------


    F.CUSTOMER.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    R.CUSTOMER.ACCOUNT.REC = ''
    Y.CUST.ACCT.ERR = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    Y.VAR.EXT.CUSTOMER = ''
    Y.FIELD.COUNT = ''
    CUSTOMER.ACCT=''
    LOC.FT.FIELD='L.FT.ACH.B.ACC':@VM:'L.FT.ACH.B.NAM':@VM:'L.ACH.PART.ID':@VM:'L.FTST.ACH.PART'
    LOC.REF.APP = 'FUNDS.TRANSFER'
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.FT.FIELD,LOC.REF.POS)
    FT.ACH.ACC.POS=LOC.REF.POS<1,1>
    FT.ACH.NAM.POS=LOC.REF.POS<1,2>
    FT.ACH.PART.POS=LOC.REF.POS<1,3>
    FT.FTST.ACH.POS=LOC.REF.POS<1,4>

    IF PGM.VERSION NE ',AI.REDO.CORP.BANK.TRANSFER' THEN
        CUSTOMER.ACCT=System.getVariable("EXT.CUSTOMER.ACCOUNTS")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            CUSTOMER.ACCT = ""
        END
    END ELSE
        CUSTOMER.ACCT=System.getVariable("EXT.SMS.ACCOUNTS")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            CUSTOMER.ACCT = ""
        END
    END

    CHANGE @SM TO @FM IN CUSTOMER.ACCT
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------


    IF APPLICATION EQ 'STANDING.ORDER' AND PGM.VERSION MATCHES ',AI.REDO.BANK.TRANSFER':@VM:',AI.REDO.CORP.BANK.TRANSFER' THEN
        STO.ID=FIELD(ID.NEW,'.',1)
        BEN.ID        =System.getVariable("CURRENT.BEN.ID")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.ID = ""
        END
        BEN.NAME      =System.getVariable("CURRENT.BEN.NAME")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.NAME = ""
        END
        BEN.ACCT.NO   =System.getVariable("CURRENT.BEN.ACCT.NO")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.ACCT.NO = ""
        END


        CHANGE @VM TO @FM IN CUSTOMER.ACCT
        CHANGE @SM TO @FM IN CUSTOMER.ACCT

        LOCATE STO.ID IN CUSTOMER.ACCT SETTING STO.POS THEN
            R.NEW(STO.CPTY.ACCT.NO)    = BEN.ACCT.NO
            R.NEW(STO.CURRENCY)        = LCCY
            R.NEW(STO.BENEFICIARY.ID)  = BEN.ID
        END
    END

    IF APPLICATION EQ 'STANDING.ORDER' AND PGM.VERSION EQ ',AI.REDO.OTHER.BNK.TRANS' THEN
        STO.ID=FIELD(ID.NEW,'.',1)
        BEN.CED=System.getVariable("CURRENT.BEN.CED")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.CED = ""
        END
        BEN.BANK=System.getVariable("CURRENT.BEN.BANK")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.BANK = ""
        END
        BEN.ID        =System.getVariable("CURRENT.BEN.ID")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.ID = ""
        END
        BEN.NAME      =System.getVariable("CURRENT.BEN.NAME")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.NAME = ""
        END
        BEN.ACCT.NO   =System.getVariable("CURRENT.BEN.ACCT.NO")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.ACCT.NO = ""
        END


        LOCATE STO.ID IN CUSTOMER.ACCT SETTING STO.POS THEN
            R.NEW(STO.CURRENCY)        = LCCY
            R.NEW(STO.BENEFICIARY.ID)  = BEN.ID
            R.NEW(STO.FT.LOC.REF.DATA)<1,1>=BEN.NAME
            R.NEW(STO.FT.LOC.REF.DATA)<1,2>=BEN.CED
            R.NEW(STO.FT.LOC.REF.DATA)<1,3>=BEN.ACCT.NO
            R.NEW(STO.FT.LOC.REF.DATA)<1,4>=BEN.BANK

        END
    END


    IF APPLICATION EQ 'FUNDS.TRANSFER' AND PGM.VERSION MATCHES ',AI.REDO.BANK.TRANSFER':@VM:',AI.REDO.CORP.BANK.TRANSFER' THEN
        BEN.ID        =System.getVariable("CURRENT.BEN.ID")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.ID = ""
        END
        BEN.NAME      =System.getVariable("CURRENT.BEN.NAME")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.NAME = ""
        END
        BEN.ACCT.NO   =System.getVariable("CURRENT.BEN.ACCT.NO")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.ACCT.NO = ""
        END
        DEBIT.ACCT.NO =System.getVariable("CURRENT.DEBIT.ACCT.NO")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            DEBIT.ACCT.NO = ""
        END

        CHANGE @VM TO @FM IN CUSTOMER.ACCT
        CHANGE @SM TO @FM IN CUSTOMER.ACCT
        LOCATE DEBIT.ACCT.NO IN CUSTOMER.ACCT SETTING FT.POS THEN
            R.NEW(FT.DEBIT.ACCT.NO)  = DEBIT.ACCT.NO
            R.NEW(FT.CREDIT.ACCT.NO) = BEN.ACCT.NO
            R.NEW(FT.BENEFICIARY.ID) = BEN.ID
            R.NEW(FT.CREDIT.CURRENCY) = LCCY
        END
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' AND PGM.VERSION EQ ',AI.REDO.OTHER.BANK.TRANSFER' THEN
        BEN.ID        =System.getVariable("CURRENT.BEN.ID")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.ID = ""
        END
        BEN.NAME      =System.getVariable("CURRENT.BEN.NAME")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.NAME = ""
        END
        BEN.ACCT.NO   =System.getVariable("CURRENT.BEN.ACCT.NO")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.ACCT.NO = ""
        END
        DEBIT.ACCT.NO =System.getVariable("CURRENT.DEBIT.ACCT.NO")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            DEBIT.ACCT.NO = ""
        END
        BEN.CEDULA=System.getVariable("CURRENT.BEN.CED")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.CEDULA = ""
        END
        BEN.BANK=System.getVariable("CURRENT.BEN.BANK")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            BEN.BANK = ""
        END

        LOCATE DEBIT.ACCT.NO IN CUSTOMER.ACCT SETTING FT.POS THEN
            R.NEW(FT.DEBIT.ACCT.NO)  = DEBIT.ACCT.NO
            R.NEW(FT.BENEFICIARY.ID) = BEN.ID
            R.NEW(FT.CREDIT.CURRENCY) = LCCY
            R.NEW(FT.LOCAL.REF)<1,FT.ACH.ACC.POS>=BEN.ACCT.NO
            R.NEW(FT.LOCAL.REF)<1,FT.ACH.NAM.POS>=BEN.NAME
            R.NEW(FT.LOCAL.REF)<1,FT.ACH.PART.POS>=BEN.CEDULA
            R.NEW(FT.LOCAL.REF)<1,FT.ACH.PART.POS>= BEN.BANK
        END
    END
    IF APPLICATION EQ 'REDO.H.SOLICITUD.CK' AND PGM.VERSION EQ ',AI.REDO.PF.INPUT' THEN
        ACCOUNT.NUM=System.getVariable("CURRENT.ACCT.NUM")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            ACCOUNT.NUM = ""
        END

        LOCATE ACCOUNT.NUM IN CUSTOMER.ACCT SETTING ACCT.POS THEN
            R.NEW(REDO.H.SOL.ACCOUNT)=ACCOUNT.NUM
        END

    END

RETURN


*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
