<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : MjoxNjQ3MTU2MjA1OkNwMTI1MjoxNjkwMjY0MjcxMTc2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:21:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
=======
=======
>>>>>>> Stashed changes
* @ValidationCode : Mjo5ODk4NTQxODU6Q3AxMjUyOjE2ODU5NDk0MjE4NDc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jun 2023 12:47:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.OUTSTANDING.LOANS(ENQ.OUT)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.OUTSTANDING.LOANS
* ODR NO      : ODR-2010-03-0176
*----------------------------------------------------------------------
*DESCRIPTION: This is Nofile Enquiry routine for getting the loan outstanding
* details and returns the data for enquiry as per the selection criteria


*IN PARAMETER: NA
*OUT PARAMETER: ENQ.OUT
*LINKED WITH: NOFILE.REDO.APAP.OUTSTANDING.LOANS
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*26.10.2010  H GANESH     ODR-2010-03-0176   INITIAL CREATION
*28-APR-2011 H GANESH           CR009        Change the Vetting value of local field
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM , SM to @SM,++ to +=
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION CALL RTN FORMAT MODIFIED
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $USING APAP.TAM
    $USING APAP.AA
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    $USING APAP.REDOENQ
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB MULTI.GET.LOCAL.REF
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    Y.FIELDS=D.FIELDS
    Y.OPERANDS=D.LOGICAL.OPERANDS
    Y.VALUE=D.RANGE.AND.VALUE
    AFF.COM=''
    CAMP.TYP=''
    Y.FINAL.ARR.ID.LIST=''
    Y.COMMON.ARRAY.TWO=''
    Y.COMMON.ARRAY.ONE=''
*add for CR039
    Y.CRITERIA.SEL = ''
    Y.SEL.POS=0
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
* All files needed throughtout the routine are opened here

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

RETURN
*----------------------------------------------------------------------
MULTI.GET.LOCAL.REF:
*----------------------------------------------------------------------
    LOC.REF.APPLICATION="AA.PRD.DES.CUSTOMER":@FM:"AA.PRD.DES.OVERDUE":@FM:"ACCOUNT"
    LOC.REF.FIELDS='L.AA.AFF.COM':@VM:'L.AA.CAMP.TY':@FM:'L.LOAN.STATUS.1':@FM:'L.OD.STATUS'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.AFF.COM=LOC.REF.POS<1,1>
    POS.L.AA.CAMP.TY=LOC.REF.POS<1,2>
    POS.L.LOAN.STATUS.1=LOC.REF.POS<2,1>
    POS.L.OD.STATUS = LOC.REF.POS<3,1>
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
* Here the main process begins for selecting the record as per selection criteria
    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''

    GOSUB AA.ARRANGEMENT.FORM
    IF AA.ARR.ID.LST NE '' THEN
        GOSUB AA.CUS.FORM.ID
        GOSUB AA.ARR.FORM.ID
        GOSUB AA.LOAN.STATUS
        GOSUB CHECK.DATE.SEL
* Add new Criteria Value Selection in order to CR039

        GOSUB GET.BILLS.SEL
        IF ENQ.ERROR EQ '' THEN
            D.RANGE.AND.VALUE  = Y.VALUE
            D.LOGICAL.OPERANDS = Y.OPERANDS
            D.FIELDS           = Y.FIELDS
*CALL REDO.APAP.OUTSTANDING.LOAN.DETAILS(Y.FINAL.PASS.IDS,Y.DATE.SEL,Y.CRITERIA.SEL,ENQ.OUT) ;*R22 MANUAL CODE CONVERSION
<<<<<<< Updated upstream
<<<<<<< Updated upstream
            APAP.REDOAPAP.redoApapOutstandingLoanDetails(Y.FINAL.PASS.IDS,Y.DATE.SEL,Y.CRITERIA.SEL,ENQ.OUT) ;*R22 MANUAL CODE CONVERSION
=======
            CALL APAP.REDOAPAP.redoApapOutstandingLoanDetails(Y.FINAL.PASS.IDS,Y.DATE.SEL,Y.CRITERIA.SEL,ENQ.OUT) ;*R22 MANUAL CODE CONVERSION
>>>>>>> Stashed changes
=======
            CALL APAP.REDOAPAP.redoApapOutstandingLoanDetails(Y.FINAL.PASS.IDS,Y.DATE.SEL,Y.CRITERIA.SEL,ENQ.OUT) ;*R22 MANUAL CODE CONVERSION
>>>>>>> Stashed changes
        END
    END
RETURN
*----------------------------------------------------------------------
CHECK.DATE.SEL:
*----------------------------------------------------------------------
    Y.FINAL.PASS.IDS = ''
    LOCATE 'DATE' IN Y.FIELDS<1> SETTING POS.DAT THEN
        Y.DATE.FIELD   = Y.FIELDS<POS.DAT>
        Y.DATE.OPERAND = Y.OPERANDS<POS.DAT>
        Y.DATE.VALUE   = Y.VALUE<POS.DAT>
        GOSUB DO.SELECTION.VALIDATION
    END ELSE
        Y.FINAL.PASS.IDS = Y.FINAL.ARR.ID.LIST
    END
    Y.IDS.CNT = DCOUNT(Y.FINAL.ARR.ID.LIST,@FM)
    Y.AA.VAR = 1
    LOOP
    WHILE Y.AA.VAR LE Y.IDS.CNT
        Y.AA.ARR.ID = Y.FINAL.ARR.ID.LIST<Y.AA.VAR>
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
        Y.LOAN.START.DATE = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
        IF Y.DATE.OPERAND EQ 1 THEN
            IF Y.LOAN.START.DATE EQ Y.DATE.VALUE THEN
                Y.FINAL.PASS.IDS<-1> = Y.AA.ARR.ID
            END
        END
        IF Y.DATE.OPERAND EQ 2 THEN
            IF Y.LOAN.START.DATE GE Y.DATE.VALUE<1,1,1> AND Y.LOAN.START.DATE LE Y.DATE.VALUE<1,1,2> THEN
                Y.FINAL.PASS.IDS<-1> = Y.AA.ARR.ID
            END
        END

        Y.AA.VAR += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

RETURN
*-------------------------------------------------------------------------------
DO.SELECTION.VALIDATION:
*-------------------------------------------------------------------------------

    IF Y.DATE.OPERAND EQ 1 THEN
        IF DCOUNT(Y.DATE.VALUE,@SM) GT 1 THEN
            ENQ.ERROR = "Only one value allowed for this operand - ":Y.DATE.FIELD
            GOSUB END1
        END
    END
    IF Y.DATE.OPERAND EQ 2 THEN
        IF DCOUNT(Y.DATE.VALUE,@SM) NE 2 THEN
            ENQ.ERROR = "Two values needs to be entered for this operand - ":Y.DATE.FIELD
            GOSUB END1
        END
    END

RETURN


*----------------------------------------------------------------------
AA.ARRANGEMENT.FORM:
*----------------------------------------------------------------------
* In this part based on selection fields, generic select statement is executed on AA.ARRANGEMENT file

    ARRANGEMENT.APPL.FLDS='PRODUCT.GROUP':@FM:'PRODUCT':@FM:'CO.CODE':@FM:'CURRENCY'
    LOOP
        REMOVE ARR.FLD FROM ARRANGEMENT.APPL.FLDS SETTING ARR.FLD.POS
    WHILE ARR.FLD:ARR.FLD.POS
        LOCATE ARR.FLD IN Y.FIELDS<1> SETTING POS1 THEN
            GOSUB UPDATE.COM.ARRAY
        END
    REPEAT


    LOCATE 'ARR.STATUS' IN Y.FIELDS<1> SETTING POS1 THEN
        D.RANGE.AND.VALUE<-1>  = Y.VALUE<POS1>
        D.LOGICAL.OPERANDS<-1> = Y.OPERANDS<POS1>
        D.FIELDS<-1>           = Y.FIELDS<POS1>
    END ELSE

        D.RANGE.AND.VALUE<-1>  = 'CURRENT':@SM:'EXPIRED'         ;* Auth Status removed as per issue mail from cristina
        D.LOGICAL.OPERANDS<-1> =  1
        D.FIELDS<-1>           = 'ARR.STATUS'
    END
    D.RANGE.AND.VALUE<-1>      = 'LENDING'
    D.LOGICAL.OPERANDS<-1>     = 1
    D.FIELDS<-1>               = 'PRODUCT.LINE'

    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.AA.ARRANGEMENT
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*        CALL REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.AA.ARR.CMD)
        APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.AA.ARR.CMD) ;*R22 Manual Code Conversion
=======
        CALL REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.AA.ARR.CMD)
>>>>>>> Stashed changes
=======
        CALL REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.AA.ARR.CMD)
>>>>>>> Stashed changes
        CALL EB.READLIST(SEL.AA.ARR.CMD,AA.ARR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)
    END

RETURN
*----------------------------------------------------------------------
AA.CUS.FORM.ID:
*----------------------------------------------------------------------
* From the select record in previous step, record are filtered based selection field L.AA.AFF.COM
* & L.AA.AFF.COM
    LOCATE 'L.AA.AFF.COM' IN Y.FIELDS<1> SETTING POS2 THEN
        AFF.COM=Y.VALUE<POS2>
    END
    LOCATE 'L.AA.CAMP.TY' IN Y.FIELDS<1> SETTING POS3 THEN
        CAMP.TYP=Y.VALUE<POS3>
    END
    IF AFF.COM NE '' AND CAMP.TYP NE '' THEN
        Y.FLAG=3
    END
    IF AFF.COM NE '' AND CAMP.TYP EQ '' THEN
        Y.FLAG=2
    END
    IF AFF.COM EQ '' AND CAMP.TYP NE '' THEN
        Y.FLAG=1
    END
    IF AFF.COM EQ '' AND CAMP.TYP EQ '' THEN
        Y.COMMON.ARRAY.ONE=AA.ARR.ID.LST
        RETURN
    END

    GOSUB AA.CUS.COMMON.FORM
RETURN
*----------------------------------------------------------------------
AA.CUS.COMMON.FORM:
*----------------------------------------------------------------------
* This part finalize the list of arrangement ID's select for L.AA.AFF.COM & L.AA.AFF.COM
    IF Y.FLAG EQ 3 THEN
        VAR2=1
        LOOP
        WHILE VAR2 LE NO.OF.REC.ARR
            ARR.ID=AA.ARR.ID.LST<VAR2>
            GOSUB GET.CUSTOMER.CONDITIONS
            Y.AFF.COMPANY=R.CONDITION<AA.CUS.LOCAL.REF,POS.L.AA.AFF.COM>
            Y.CAMP.TYPE=  R.CONDITION<AA.CUS.LOCAL.REF,POS.L.AA.CAMP.TY>
            IF AFF.COM EQ Y.AFF.COMPANY AND CAMP.TYP EQ Y.CAMP.TYPE THEN
                Y.COMMON.ARRAY.ONE<-1>=ARR.ID
            END
            VAR2 += 1 ;*R22 AUTO CODE CONVERSION
        REPEAT
    END
    IF Y.FLAG EQ 2 THEN
        VAR2=1
        LOOP
        WHILE VAR2 LE NO.OF.REC.ARR
            ARR.ID=AA.ARR.ID.LST<VAR2>
            GOSUB GET.CUSTOMER.CONDITIONS
            Y.AFF.COMPANY=R.CONDITION<AA.CUS.LOCAL.REF,POS.L.AA.AFF.COM>
            IF AFF.COM EQ Y.AFF.COMPANY THEN
                Y.COMMON.ARRAY.ONE<-1>=ARR.ID
            END
            VAR2 += 1
        REPEAT
    END
    IF Y.FLAG EQ 1 THEN
        VAR2=1
        LOOP
        WHILE VAR2 LE NO.OF.REC.ARR
            ARR.ID=AA.ARR.ID.LST<VAR2>
            GOSUB GET.CUSTOMER.CONDITIONS
            Y.CAMP.TYPE=  R.CONDITION<AA.CUS.LOCAL.REF,POS.L.AA.CAMP.TY>
            IF CAMP.TYP EQ Y.CAMP.TYPE THEN
                Y.COMMON.ARRAY.ONE<-1>=ARR.ID
            END
            VAR2 += 1
        REPEAT
    END
RETURN
*----------------------------------------------------------------------
GET.CUSTOMER.CONDITIONS:
*----------------------------------------------------------------------
* This part used to read the latest customer product condition record
    EFF.DATE = ''
    PROP.CLASS='CUSTOMER'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
RETURN
*----------------------------------------------------------------------
AA.ARR.FORM.ID:
*----------------------------------------------------------------------
* From the list of arrangement ID's selected in previous step, Dept.code select field is check with that
    LOCATE 'DEPT.CODE' IN Y.FIELDS<1> SETTING POS4 THEN
        Y.SEL.DEPT.OFF=Y.VALUE<POS4>
    END ELSE
        Y.COMMON.ARRAY.TWO=Y.COMMON.ARRAY.ONE
        RETURN
    END
    IF Y.SEL.DEPT.OFF THEN
        Y.COM.ARY.CNT=DCOUNT(Y.COMMON.ARRAY.ONE,@FM)
        VAR3=1
        LOOP
        WHILE VAR3 LE Y.COM.ARY.CNT
            Y.ARR.ID=Y.COMMON.ARRAY.ONE<VAR3>
            APAP.TAM.redoConvertAccount(IN.ACC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)
            CALL F.READ(FN.ACCOUNT,OUT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            Y.DAO=R.ACCOUNT<AC.ACCOUNT.OFFICER>
            IF Y.DAO EQ Y.SEL.DEPT.OFF THEN
                Y.COMMON.ARRAY.TWO<-1>=Y.ARR.ID
            END
            VAR3 += 1
        REPEAT
    END
RETURN
*----------------------------------------------------------------------
GET.LOAN.STATUS.1:
*-----------------
    R.AA.ACCOUNT.DETAILS = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ACCOUNT.DETAILS.ERR)
    Y.LN.STA = R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
RETURN
*----------------------------------------------------------------------
AA.LOAN.STATUS:
*--------------
    LOCATE 'LOAN.STATUS' IN Y.FIELDS<1> SETTING POS5 THEN
        Y.LOAN.STATUS.FIELD   = Y.FIELDS<POS5>
        Y.LOAN.STATUS.VALUE   = Y.VALUE<POS5>
        Y.LOAN.STATUS.OPERAND = Y.OPERANDS<POS5>
    END
    LOCATE 'AGING.STATUS' IN Y.FIELDS<1> SETTING POS5 THEN
        Y.AGING.STATUS.FIELD   = Y.FIELDS<POS5>
        Y.AGING.STATUS.OPERAND = Y.OPERANDS<POS5>
        Y.AGING.STATUS.VALUE   = Y.VALUE<POS5>
    END
    BEGIN CASE
        CASE Y.LOAN.STATUS.FIELD EQ '' AND Y.AGING.STATUS.FIELD EQ ''
            Y.FINAL.ARR.ID.LIST  = Y.COMMON.ARRAY.TWO
        CASE Y.LOAN.STATUS.FIELD EQ '' AND Y.AGING.STATUS.FIELD NE ''
            GOSUB CHECK.AGING.STATUS
        CASE Y.LOAN.STATUS.FIELD NE '' AND Y.AGING.STATUS.FIELD EQ ''
            GOSUB CHECK.LOAN.STATUS
        CASE Y.LOAN.STATUS.FIELD NE '' AND Y.AGING.STATUS.FIELD NE ''
            GOSUB CHECK.LOAN.AGING.STATUS
    END CASE

RETURN

*----------------------------------------------------------
CHECK.AGING.STATUS:
*----------------------------------------------------------
    Y.AGE.VAR = 1
    Y.AGE.AA.CNT = DCOUNT(Y.COMMON.ARRAY.TWO,@FM)
    LOOP
    WHILE Y.AGE.VAR LE Y.AGE.AA.CNT
        Y.AA.ID = Y.COMMON.ARRAY.TWO<Y.AGE.VAR>
        IN.ACC.ID  = ''
        Y.LOAN.ACC = ''
        APAP.TAM.redoConvertAccount(IN.ACC.ID,Y.AA.ID,Y.LOAN.ACC,ERR.TEXT)
        CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT<AC.LOCAL.REF,POS.L.OD.STATUS> EQ Y.AGING.STATUS.VALUE THEN
            Y.FINAL.ARR.ID.LIST<-1> = Y.AA.ID
        END
        Y.AGE.VAR += 1
    REPEAT
RETURN
*----------------------------------------------------------
CHECK.LOAN.STATUS:
*----------------------------------------------------------

    Y.AGE.VAR = 1
    Y.AGE.AA.CNT = DCOUNT(Y.COMMON.ARRAY.TWO,@FM)
    LOOP
    WHILE Y.AGE.VAR LE Y.AGE.AA.CNT
        Y.AA.ID = Y.COMMON.ARRAY.TWO<Y.AGE.VAR>
        GOSUB GET.OVERDUE.COND
        IF Y.AA.LOAN.STATUS EQ Y.LOAN.STATUS.VALUE THEN
            Y.FINAL.ARR.ID.LIST<-1> = Y.AA.ID
        END
        Y.AGE.VAR += 1
    REPEAT
RETURN

*----------------------------------------------------------
CHECK.LOAN.AGING.STATUS:
*----------------------------------------------------------

    Y.AGE.VAR = 1
    Y.AGE.AA.CNT = DCOUNT(Y.COMMON.ARRAY.TWO,@FM)
    LOOP
    WHILE Y.AGE.VAR LE Y.AGE.AA.CNT
        Y.AA.ID    = Y.COMMON.ARRAY.TWO<Y.AGE.VAR>
        IN.ACC.ID  = ''
        Y.LOAN.ACC = ''
        APAP.TAM.redoConvertAccount(IN.ACC.ID,Y.AA.ID,Y.LOAN.ACC,ERR.TEXT)
        CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        GOSUB GET.OVERDUE.COND
        IF R.ACCOUNT<AC.LOCAL.REF,POS.L.OD.STATUS> EQ Y.AGING.STATUS.VALUE AND Y.AA.LOAN.STATUS EQ Y.LOAN.STATUS.VALUE THEN
            Y.FINAL.ARR.ID.LIST<-1> = Y.AA.ID
        END
        Y.AGE.VAR += 1
    REPEAT

RETURN


*----------------------------------------------------------------------
GET.OVERDUE.COND:
*----------------------------------------------------------------------

    EFF.DATE        = ''
    PROP.CLASS      = 'OVERDUE'
    PROPERTY        = ''
    R.CONDITION.OVERDUE = ''
    ERR.MSG = ''
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
    Y.AA.LOAN.STATUS = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1,1>

RETURN
*----------------------------------------------------------------------
GET.BILLS.SEL:      * added for CR039
*----------------------------------------------------------------------
    Y.SEL.POS=0
    LOCATE 'DELAYED.BILLS.AMT' IN Y.FIELDS<1> SETTING Y.SEL.POS THEN
        Y.CRITERIA.SEL<1> = Y.VALUE<Y.SEL.POS>
        Y.CRITERIA.SEL<2> = Y.OPERANDS<Y.SEL.POS>
        IF NOT (ISDIGIT (Y.CRITERIA.SEL<1>)) THEN
            ENQ.ERROR<-1>="ERROR EL CRITERIO PARA Cant. Cuotas Atraso DEBE SER NUMERICO"
            RETURN
        END
        IF (Y.CRITERIA.SEL<2> EQ '3' OR Y.CRITERIA.SEL<2> EQ '8') AND Y.CRITERIA.SEL<1> LE 0 THEN
            ENQ.ERROR<-1>="ERROR EN EL CRITERIO DE FILTRO PARA Cant. Cuotas Atraso "
            RETURN
        END
        IF Y.CRITERIA.SEL<1> LT 0 THEN
            ENQ.ERROR<-1>="ERROR EL CRITERIO PARA Cant. Cuotas Atraso DEBE SER NUMERICO POSITIVO"
            RETURN
        END

    END

RETURN
*----------------------------------------------------------------------
UPDATE.COM.ARRAY:
*----------------------------------------------------------------------
    D.RANGE.AND.VALUE<-1>  = Y.VALUE<POS1>
    D.LOGICAL.OPERANDS<-1> = Y.OPERANDS<POS1>
    D.FIELDS<-1>           = Y.FIELDS<POS1>
RETURN
*----------------------------------------------------------------------
END1:
END
