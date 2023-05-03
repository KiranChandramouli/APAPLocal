* @ValidationCode : MjotMTQ5NjMyMDA2MzpDcDEyNTI6MTY4MjUwMjY2MzY2MTpJVFNTOi0xOi0xOjEzODY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 15:21:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1386
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOFILE.INVST.DEADLINE.RPT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.APAP.NOFILE.INVST.DEADLINE.RPT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOFILE.INVST.DEADLINE.RPT is a no-file enquiry routine for the enquiries REDO.APAP.ENQ.INVST.DEADLINE.RPT
*                    and REDO.APAP.ER.INVST.DEADLINE.RPT, the routine based on the selection criteria
*                    selects the records from AZ.ACCOUNT and displays the processed records
*
*In Parameter      : N/A
*Out Parameter     : Y.OUT.ARRAY
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference                      Description
*   ------         ------               -------------                    -------------
*  14/09/2010      MD.PREETHI          ODR-2010-03-0118 109                 Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM ,= to EQ , ++ to +=
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.RELATION
    $INSERT I_F.AZ.PRODUCT.PARAMETER
* Tus start
    $INSERT I_F.EB.CONTRACT.BALANCES
* Tus end

MAIN.PARA:
**********

    GOSUB INIT
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN

INIT:
*****
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT=''
    FN.CUSTOMER ='F.CUSTOMER'
    F.CUSTOMER=''
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    FN.DEPT.ACCT.OFFICER='F.DEPT.ACCT.OFFICER'
    F.DEPT.ACCT.OFFICER=''
    FN.RELATION='F.RELATION'
    F.RELATION=''
    FN.AZ.PRODUCT.PARAMETER='F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER=''
    Y.INVST.CUS.NAMES=''
    Y.TERM=''
    Y.NEXT.INT.PAY.DATE=''
    Y.STATUS=''
    Y.ADDRESS=''
    Y.CUR.AMT=''
    LOC.L.AC.PAYMT.MODE.POS=''
    Y.TELEPHONE=''
    Y.OPEN.DATE=''
    Y.CLIENT.CODE=''
    Y.EXP.DATE = ''
    Y.AGENCY = ''
    Y.INVST.TYPE = ''
    Y.AZ.SORT.VAL =''
    Y.SORT.ARR = ''
    Y.ACC.LIST = ''
    Y.REGION=''
    Y.INVST.NO=''

RETURN

OPEN.PARA:
**********
    CALL OPF(FN.RELATION,F.RELATION)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
RETURN

PROCESS.PARA:
**************
    IF RUNNING.UNDER.BATCH THEN
        SEL.CMD.AZ = 'SELECT ':FN.AZ.ACCOUNT:' WITH MATURITY.DATE EQ ':TODAY
    END ELSE
        GOSUB GET.PROCESSED.IDS
    END

    CALL EB.READLIST(SEL.CMD.AZ,SEL.LIST.AZ,'',NO.OF.REC.AZ,SEL.ERR.AZ)

    IF NOT(SEL.LIST.AZ) THEN
        RETURN
    END
    GOSUB GET.SORTED.IDS
    IF NOT(Y.ACC.LIST) THEN
        RETURN
    END
    GOSUB GET.DETAILS
RETURN

GET.PROCESSED.IDS:
******************

    SEL.CMD.AZ = 'SELECT ':FN.AZ.ACCOUNT
    LOCATE "EXP.DATE" IN D.FIELDS<1> SETTING Y.EXP.POS THEN
        Y.EXP.DATE = D.RANGE.AND.VALUE<Y.EXP.POS>
    END
    IF Y.EXP.DATE THEN
        SEL.CMD.AZ:= " WITH MATURITY.DATE EQ ":Y.EXP.DATE
    END
    LOCATE "AGENCY" IN D.FIELDS<1> SETTING Y.AGY.POS THEN
        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGY.POS>
    END
    IF Y.EXP.DATE AND Y.AGENCY THEN
        SEL.CMD.AZ:= " AND WITH CO.CODE EQ ":Y.AGENCY
    END
    IF NOT(Y.EXP.DATE) AND Y.AGENCY THEN
        SEL.CMD.AZ:= " WITH CO.CODE EQ ":Y.AGENCY
    END
    LOCATE "INVST.TYPE" IN D.FIELDS<1> SETTING Y.INV.POS THEN
        Y.INVST.TYPE = D.RANGE.AND.VALUE<Y.INV.POS>
    END
    IF NOT(Y.EXP.DATE) AND NOT(Y.AGENCY) AND Y.INVST.TYPE THEN
        SEL.CMD.AZ:=" WITH CATEGORY EQ ":Y.INVST.TYPE
    END
    IF (Y.EXP.DATE OR Y.AGENCY) AND Y.INVST.TYPE THEN
        SEL.CMD.AZ:= " AND WITH CATEGORY EQ ":Y.INVST.TYPE
    END


RETURN

GET.SORTED.IDS:
*****************

    LOOP
        REMOVE AZ.ACCOUNT.ID FROM SEL.LIST.AZ SETTING Y.AZ.POS
    WHILE AZ.ACCOUNT.ID : Y.AZ.POS
        CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZ.ERR)
        ACCOUNT.ID = AZ.ACCOUNT.ID
        CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
        Y.SORT.VAL = R.AZ.ACCOUNT<AZ.CO.CODE>:FMT(R.ACCOUNT<AC.ACCOUNT.OFFICER>,'R%12'):FMT(R.AZ.ACCOUNT<AZ.CATEGORY>,'R%5'):R.AZ.ACCOUNT<AZ.CURRENCY>
        Y.AZ.SORT.VAL<-1>= AZ.ACCOUNT.ID:@FM:Y.SORT.VAL
        Y.SORT.ARR<-1>= Y.SORT.VAL
    REPEAT

    Y.SORT.ARR = SORT(Y.SORT.ARR)

    LOOP
        REMOVE Y.ARR.ID FROM Y.SORT.ARR SETTING Y.ARR.POS
    WHILE Y.ARR.ID : Y.ARR.POS
        LOCATE Y.ARR.ID IN Y.AZ.SORT.VAL SETTING Y.FM.POS THEN
            Y.ACC.LIST<-1> = Y.AZ.SORT.VAL<Y.FM.POS-1>
            DEL Y.AZ.SORT.VAL<Y.FM.POS>
            DEL Y.AZ.SORT.VAL<Y.FM.POS-1>
        END
    REPEAT

RETURN

GET.DETAILS:
************
    GOSUB FIND.MULTI.LOCAL.REF
    LOOP
        REMOVE AZ.ACCOUNT.ID FROM Y.ACC.LIST SETTING Y.ACC.POS
    WHILE AZ.ACCOUNT.ID : Y.ACC.POS
        GOSUB GET.AZ.ACCOUNT.DETAILS
        GOSUB GET.ACCOUNT.DETAILS
        GOSUB GET.CUSTOMER.DETAILS


        Y.OUT.ARRAY<-1> = Y.EXP.DATE:'*':Y.AGENCY:'*':Y.ACC.EXE:'*':Y.REGION:'*':Y.INVST.TYPE:'*':Y.CCY:'*':Y.PREV.INVST.NO:'*':Y.INVST.NO:'*':Y.INVST.CUS.NAMES:'*':Y.CLIENT.CODE:'*':Y.INVST.AMT:'*':Y.CUR.AMT:'*':Y.TERM:'*':Y.OPEN.DATE:'*':Y.INT.RATE:'*':Y.INT.PYMT.DATE:'*':Y.INT.METHOD.PYMT:'*':Y.PAY.ACC.INT:'*':Y.NEXT.INT.PAY.DATE:'*':Y.STATUS:'*':Y.NEXT.RENEW.DATE:'*':Y.BSP.AMT:'*':Y.TELEPHONE:'*':Y.ADDRESS
        GOSUB GET.NULLIFY.VALUES
    REPEAT
RETURN

GET.AZ.ACCOUNT.DETAILS:
************************


    CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZ.ERR)
    Y.EXP.DATE = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    Y.AGENCY = R.AZ.ACCOUNT<AZ.CO.CODE>
    Y.INVST.TYPE = R.AZ.ACCOUNT<AZ.CATEGORY>
    Y.CCY = R.AZ.ACCOUNT<AZ.CURRENCY>
    Y.INVST.NO = AZ.ACCOUNT.ID
    Y.INVST.AMT = R.AZ.ACCOUNT<AZ.ORIG.PRINCIPAL>
    GOSUB GET.TERM
    Y.INT.RATE = R.AZ.ACCOUNT<AZ.INTEREST.RATE>

    Y.NEXT.RENEW.DATE = R.AZ.ACCOUNT<AZ.ROLLOVER.DATE>

RETURN

GET.ACCOUNT.DETAILS:
********************

    ACCOUNT.ID = AZ.ACCOUNT.ID
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
*Tus start
    R.ECB = ''
    ECB.ERR = ''
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",ACCOUNT.ID,R.ECB,ECB.ERR)
* Tus end
    Y.ACC.EXE =R.ACCOUNT<AC.ACCOUNT.OFFICER>
    GOSUB GET.REGION
    Y.PREV.INVST.NO =R.ACCOUNT<AC.ALT.ACCT.TYPE>
    GOSUB GET.INVST.CUS.NAME
    GOSUB GET.CURRENT.AMT
    Y.INT.PYMT.DATE =R.ACCOUNT<AC.CAP.DATE.CR.INT,1>
    Y.INT.METHOD.PYMT = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.PAYMT.MODE.POS>
    Y.PAY.ACC.INT =R.ACCOUNT<AC.ACCR.CR.AMOUNT>
    GOSUB GET.NEXT.INT.PAY.DATE
    GOSUB GET.STATUS
    Y.BSP.AMT = R.ACCOUNT<AC.LOCKED.AMOUNT>

RETURN

GET.REGION:
***********

    Y.DAO = Y.ACC.EXE[8]

    IF LEN(Y.DAO) LT 8 THEN
        Y.REGION = ""
        RETURN
    END

    Y.REGION = Y.DAO[1,2]

RETURN

GET.INVST.CUS.NAME:
*******************
    Y.CLIENT.CODE = R.ACCOUNT<AC.CUSTOMER>
    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    END
    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END
    Y.RELATION.COUNT = DCOUNT(R.ACCOUNT<AC.RELATION.CODE>,@VM)
    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE Y.RELATION.COUNT
        RELATION.ID = R.ACCOUNT<AC.RELATION.CODE,Y.COUNT>
        IF RELATION.ID LT 500 AND RELATION.ID GT 529 THEN
            CONTINUE
        END
        CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,Y.REL.ERR)
        Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
        CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.COUNT>
        CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN ;*R22 AUTO CODE CONVERSION
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
        IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
        END
        Y.CUS.NAMES := @VM:Y.REL.DESC:'-':Y.CUS.NAME
        Y.CLIENT.CODE := @VM:CUSTOMER.ID
        Y.COUNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
    Y.INVST.CUS.NAMES = Y.CUS.NAMES
RETURN

GET.CURRENT.AMT:
*****************

    IF R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.REINVESTED.POS> NE 'YES' THEN
        Y.CUR.AMT = R.AZ.ACCOUNT<AZ.ORIG.PRINCIPAL>
        RETURN
    END
    ACCOUNT.ID = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
    IF ACCOUNT.ID THEN
        CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
    END
    Y.AZ.AC.ORIG.PRINC = R.AZ.ACCOUNT<AZ.ORIG.PRINCIPAL>
*  Tus start
*Y.AC.WORK.BAL = R.ACCOUNT<AC.WORKING.BALANCE>
    Y.AC.WORK.BAL = R.ECB<ECB.WORKING.BALANCE>
*  Tus end
    Y.CUR.AMT = Y.AZ.AC.ORIG.PRINC + Y.AC.WORK.BAL
RETURN

GET.TERM:
*********
    Y.OPEN.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
    Y.MAT.DATE = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    CALL EB.NO.OF.MONTHS(Y.OPEN.DATE, Y.MAT.DATE,Y.TERM)
RETURN
GET.NEXT.INT.PAY.DATE:
**********************
    IF NOT(Y.INT.PYMT.DATE) THEN
        Y.NEXT.INT.PAY.DATE = ''
        RETURN
    END
    AZ.PRODUCT.PARAMETER.ID = R.AZ.ACCOUNT<AZ.ALL.IN.ONE.PRODUCT>
    CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,AZ.PRODUCT.PARAMETER.ID,R.AZ.PRODUCT.PARAMETER,Y.AZ.PARM.ERR)
    Y.FQU= R.AZ.PRODUCT.PARAMETER<AZ.APP.CR.INT.FQU>
    COMI = Y.INT.PYMT.DATE:Y.FQU
    CALL CFQ
    IF LEN(Y.FQU) EQ 3 THEN
        Y.NEXT.INT.PAY.DATE = COMI[1,6]:'01'
    END ELSE
        Y.NEXT.INT.PAY.DATE = COMI[1,8]
    END
    IF LEN(Y.NEXT.INT.PAY.DATE) EQ 6 THEN
        Y.NEXT.INT.PAY.DATE = Y.NEXT.INT.PAY.DATE:'01'
    END
RETURN

GET.STATUS:
***********

    IF R.ACCOUNT<AC.CLOSURE.DATE> THEN
        Y.STATUS = 'CLOSED'
        RETURN
    END
    Y.STATUS = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.STATUS1.POS>
RETURN

GET.CUSTOMER.DETAILS:
*********************
    CUSTOMER.ID = R.AZ.ACCOUNT<AZ.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)

    Y.TELEPHONE = R.CUSTOMER<EB.CUS.PHONE.1>
    IF R.CUSTOMER<EB.CUS.ADDRESS> THEN
        Y.ADDRESS<-1>= R.CUSTOMER<EB.CUS.ADDRESS>
    END
    IF R.CUSTOMER<EB.CUS.TOWN.COUNTRY> THEN
        Y.ADDRESS<-1>= R.CUSTOMER<EB.CUS.TOWN.COUNTRY>
    END
    IF R.CUSTOMER<EB.CUS.POST.CODE> THEN
        Y.ADDRESS<-1>= R.CUSTOMER<EB.CUS.POST.CODE>
    END
    CHANGE @FM TO @VM IN Y.ADDRESS
RETURN


GET.NULLIFY.VALUES:
*******************
    Y.EXP.DATE=''
    Y.AGENCY=''
    Y.ACC.EXE=''
    Y.REGION=''
    Y.INVST.TYPE=''
    Y.CCY=''
    Y.PREV.INVST.NO=''
    Y.INVST.NO=''
    Y.INVST.CUS.NAMES=''
    Y.CLIENT.CODE=''
    Y.INVST.AMT=''
    Y.CUR.AMT=''
    Y.TERM=''
    Y.OPEN.DATE=''
    Y.INT.RATE=''
    Y.INT.PYMT.DATE=''
    Y.INT.METHOD.PYMT=''
    Y.PAY.ACC.INT=''
    Y.NEXT.INT.PAY.DATE=''
    Y.STATUS=''
    Y.NEXT.RENEW.DATE=''
    Y.BSP.AMT=''
    Y.TELEPHONE=''
    Y.ADDRESS =''
RETURN

FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'CUSTOMER':@FM:'ACCOUNT'
    FLD.ARRAY = 'L.CU.TIPO.CL':@FM:'L.AC.REINVESTED':@VM:'L.AC.PAYMT.MODE':@VM:'L.AC.STATUS1'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CU.TIPO.CL.POS =  FLD.POS<1,1>
    LOC.L.AC.REINVESTED.POS = FLD.POS<2,1>
    LOC.L.AC.PAYMT.MODE.POS = FLD.POS<2,2>
    LOC.L.AC.STATUS1.POS = FLD.POS<2,3>
RETURN
END
