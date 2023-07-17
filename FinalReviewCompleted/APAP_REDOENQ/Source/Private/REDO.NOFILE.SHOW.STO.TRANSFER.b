* @ValidationCode : MjotMTY3NjI3ODcwNjpDcDEyNTI6MTY4MjA3MzM4NDk3NjpJVFNTOi0xOi0xOjEyNDQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1244
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.SHOW.STO.TRANSFER(LIST.STO.TRF)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name : REDO.NOFILE.SHOW.STO.TRANSFER
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.LOAN.ACCT.TO
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
** 17-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM, ++ to +=
** 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.ACCOUNT


    GOSUB INITIALISE
    GOSUB GET.ARCIB.PARAM.DETAILS
    GOSUB GET.STO.TRF.DETAILS
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    STO.WRK.ID=''
    CUSTOMER.ID = System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - start
        CUSTOMER.ID = ""
    END					;*R22 Auto conversion - END

    FN.STO = 'F.STANDING.ORDER'
    F.STO = ''
    CALL OPF(FN.STO,F.STO)

    FN.CUS.ACC = 'F.CUSTOMER.ACCOUNT'
    F.CUS.ACC = ''
    CALL OPF(FN.CUS.ACC,F.CUS.ACC)

    FN.ARCIB.PARAM = 'F.AI.REDO.ARCIB.PARAMETER'
    F.ARCIB.PARAM = ''
    CALL OPF(FN.ARCIB.PARAM,F.ARCIB.PARAM)

    FN.STO.ACC.LIST= 'F.STO.ACCOUNT.LIST'
    F.STO.ACC.LIST = ''
    CALL OPF(FN.STO.ACC.LIST,F.STO.ACC.LIST)

    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

    FN.RELATION.CUSTOMER = 'F.RELATION.CUSTOMER'
    F.RELATION.CUSTOMER  = ''
    CALL OPF(FN.RELATION.CUSTOMER,F.RELATION.CUSTOMER)

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF  = ''

    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    FN.ACCOUNT =  'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    APP.STO = 'STANDING.ORDER':@FM:'BENEFICIARY'
    APP.FLD = 'L.STO.START.DTE':@FM:'L.BEN.ACCOUNT'

    STO.LOC.POS = ''
    CALL MULTI.GET.LOC.REF(APP.STO,APP.FLD,STO.LOC.POS)
    STO.FLD.VAL = STO.LOC.POS<1,1>
    POS.L.BEN.ACCOUNT = STO.LOC.POS<2,1>

    SYSTEM.ID = 'SYSTEM'
    TRANSFER.CODE = ''

    CALL CACHE.READ(FN.ARCIB.PARAM,SYSTEM.ID,R.ARCIB.PARAM,ARC.ERR)
    IF NOT(ARC.ERR) THEN
        AI.PARAM.PROD =R.ARCIB.PARAM<AI.PARAM.PRODUCT>
        AI.PARAM.TYPE=R.ARCIB.PARAM<AI.PARAM.TRANSACTION.TYPE>
    END

RETURN

************************
GET.ARCIB.PARAM.DETAILS:
************************

    LOCATE 'STANDING.ORDER' IN AI.PARAM.PROD<1,1> SETTING AI.PARAM.PROD.POS THEN
        LOCATE 'OWN-TRANSFER' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            TRANSFER.CODE<1,-1> = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>

        END
        LOCATE 'APAP-TRANSFER' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            TRANSFER.CODE<1,-1> = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END

        LOCATE 'THIRD-TRANSFER' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            TRANSFER.CODE<1,-1> = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END

    END

RETURN
*----------------------------------------------------------------------------
GET.STO.TRF.DETAILS:
*-----------------------------------------------------------------------------


    R.CUST.ACC = ''
    CORRECT.STO.ID=''

    CALL F.READ(FN.CUS.ACC,CUSTOMER.ID,R.CUST.ACC,F.CUS.ACC,CUS.ACC.ERR)
    GOSUB MINOR.CUST.PARA
    IF  R.CUST.ACC THEN

        LOOP

            REMOVE ACCT.ID FROM R.CUST.ACC SETTING CUST.ACC.POS

        WHILE ACCT.ID:CUST.ACC.POS
            CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
            GOSUB RELATION.PARA
            CALL F.READ(FN.STO.ACC.LIST,ACCT.ID,R.STO.LIST.REC,F.STO.ACC.LIST,STO.ACC.ERR)
            TOT.STO.CNT = DCOUNT(R.STO.LIST.REC,@FM)
            IF R.STO.LIST.REC AND NOT(Y.FLAG) THEN
                GOSUB CROSS.CHECK.STO
            END

        REPEAT
    END

RETURN
*----------------*
MINOR.CUST.PARA:
*----------------*

    CALL F.READ(FN.JOINT.CONTRACTS.XREF,CUSTOMER.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,JNT.XREF.ERR)
    R.CUST.ACC<-1> = R.JOINT.CONTRACTS.XREF
RETURN
*----------------*
RELATION.PARA:
*----------------*
    Y.FLAG = ''
    CUR.ACCT.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    Y.RELATION.CODE   = R.ACCOUNT<AC.RELATION.CODE>
    Y.REL.PARAM = R.ARCIB.PARAM<AI.PARAM.RELATION.CODE>
    CHANGE @VM TO @FM IN Y.REL.PARAM
    IF CUR.ACCT.CUSTOMER NE CUSTOMER.ID THEN
        IF Y.REL.PARAM THEN
            Y.CNT.REL.CODE  = DCOUNT(Y.RELATION.CODE,@VM)
            Y.CNT.REL = 1
            LOOP
            WHILE Y.CNT.REL LE Y.CNT.REL.CODE
                Y.REL.CODE = Y.RELATION.CODE<1,Y.CNT.REL>
                LOCATE Y.REL.CODE IN Y.REL.PARAM SETTING Y.REL.POS THEN
                    RETURN
                END ELSE
                    Y.FLAG = 1
                END
                Y.CNT.REL += 1
            REPEAT
        END ELSE
            Y.FLAG = 1
        END
    END

RETURN
****************
CROSS.CHECK.STO:
****************


    LOOP
        REMOVE NO.ID.STO FROM R.STO.LIST.REC SETTING NO.ID.POS
    WHILE NO.ID.STO : NO.ID.POS

        CORRECT.STO.ID = ACCT.ID:".":NO.ID.STO
        R.STO.REC = ''
        CALL F.READ(FN.STO,CORRECT.STO.ID,R.STO.REC,F.STO,STO.ERR)

        IF R.STO.REC THEN
            STO.PAY.MTD = R.STO.REC<STO.PAY.METHOD>
            GOSUB FINAL.ARRAY.PARA
        END
    REPEAT
RETURN
*****************
FINAL.ARRAY.PARA:
*****************
    Y.BANK = ''
    IF STO.PAY.MTD MATCHES TRANSFER.CODE THEN
        STO.BEN.ID = R.STO.REC<STO.BENEFICIARY.ID>

        STO.AMT.BAL = R.STO.REC<STO.CURRENT.AMOUNT.BAL>
*   STO.ST.DATE = R.STO.REC<STO.LOCAL.REF><1,STO.FLD.VAL>
        STO.ST.DATE = R.STO.REC<STO.DATE.TIME>
        STO.ST.DATE = '20':STO.ST.DATE[1,6]
        STO.CURR.DTE = R.STO.REC<STO.CURRENT.FREQUENCY>[1,8]
        STO.END.DTE = R.STO.REC<STO.CURRENT.END.DATE>
        CALL CACHE.READ(FN.BENEFICIARY, STO.BEN.ID, R.BENEFICIARY, BENEFICIARY.ERR) ;*R22 Auto conversion
        STO.CPTY.NO = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.ACCOUNT>
        Y.BANK = 'NONAPAP'
        IF NOT(STO.CPTY.NO) THEN
            STO.CPTY.NO = R.STO.REC<STO.CPTY.ACCT.NO>
            Y.BANK = 'APAP'
        END
        LIST.STO.TRF<-1> = CORRECT.STO.ID:"@":STO.BEN.ID:"@":STO.AMT.BAL:"@":STO.ST.DATE:"@":STO.CURR.DTE:"@":STO.END.DTE:"@":ACCT.ID:"@":STO.CPTY.NO:"@":Y.BANK
    END
RETURN
*-----------------------------------------------------------------------------
END
*-----------------
*---------*END OF SUBROUTINE*-------------------------------
