* @ValidationCode : MjotMjI3NTEzMzY3OkNwMTI1MjoxNzA0MzcwOTMzMDUxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jan 2024 17:52:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.OFFICER.OF.COMPANY(CUSTOMER.ID)
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN5-GR04
*
* Attached To           : Batch - BNK/REDO.B.OFFICER.OF.COMPANY
*
* Attached As           : Multi Threaded Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : CUSTOMER.ID - Contains the Customer Number
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#2 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* REGN5-GR04             Kalyani L K                     2014-02-18           Initial Draft
*                        Rashmitha M                     2014-03-19         Company Id, Company name, Doc end date
*                                                                           displayed as per the required format
* PACS00361956           Ashokkumar.V.P                  23/02/2015         Optimized the relation between the customer
* R22 Auto conversion     Conversion tool                04-APR-2023       FM TO @FM, VM to @VM, SM to @SM
* Manual R22 conversion     Harishvikram C               04-APR-2023       CALL method format changed
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUST.DOCUMENT
    $INSERT I_F.COMPANY
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.OFFICER.OF.COMPANY.COMMON
    $USING APAP.REDOSRTN
    $USING APAP.REDOCHNLS
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**
    GOSUB PROCESS.PARA
 
RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    RELATION.CUSTOMER.ID = CUSTOMER.ID
    GOSUB READ.RELATION.CUSTOMER

    GOSUB READ.CUSTOMER

    FL.CUSTOMER.ID = CUSTOMER.ID
    R.FL.CUSTOMER  = R.CUSTOMER

    IF NOT(R.CUSTOMER) THEN
        GOSUB CHECK.FATAL.ERROR
    END

    IF NOT(R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS>) THEN
        RETURN
    END

    GOSUB GET.FL.CSPARE.VALUES
    GOSUB CHECK.RELATION.CODES

RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.FL.CSPARE.VALUES:
*********************
* In this para of the program, the variable C$SPARE is assigned with values
**

    LANG.CODE  = R.COMPANY(EB.COM.LANGUAGE.CODE)

    CUST.DOCUMENT.ID = FL.CUSTOMER.ID :'*': FIELD.DOC.VAL
    GOSUB READ.CUST.DOCUMENT

    IF NOT(R.CUST.DOCUMENT<CUS.DOC.SIG.DATE>) THEN
        C$SPARE(462) = ''
    END ELSE
*20140319 (S)
        Y.DOC.END.DATE=R.CUST.DOCUMENT<CUS.DOC.SIG.DATE>
        Y.DOC.END.DATE=ICONV(Y.DOC.END.DATE,'D')
        Y.DOC.END.DATE=OCONV(Y.DOC.END.DATE,'D4/E')
        C$SPARE(462) = Y.DOC.END.DATE
*20140319 (E)
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
CHECK.RELATION.CODES:
*********************
* In this para of the program, the relation codes defined for Customer are checked
**
    PRM.REL.COUNT = DCOUNT(R.RELATION.CUSTOMER<EB.RCU.IS.RELATION>,@VM)
    PRM.REL.INIT  = 1

    LOOP
    WHILE PRM.REL.INIT LE PRM.REL.COUNT
        LOCATE R.RELATION.CUSTOMER<EB.RCU.IS.RELATION,PRM.REL.INIT> IN FIELD.REL.VAL<1> SETTING REL.CODE.POS THEN
            SL.CUSTOMER.ID = R.RELATION.CUSTOMER<EB.RCU.OF.CUSTOMER,PRM.REL.INIT>
            GOSUB GET.SL.CUST.VALUES
        END

        PRM.REL.INIT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------------
*******************
GET.SL.CUST.VALUES:
*******************
* In this para of the program, the second level customer details are fetched
**
    CUSTOMER.ID = SL.CUSTOMER.ID
    GOSUB READ.CUSTOMER

    R.SL.CUSTOMER = R.CUSTOMER

    PRODUCT.GROUP = ''
    REL.CODE      = ''
*   CALL REDO.S.REP.CUSTOMER.EXTRACT(SL.CUSTOMER.ID,PRODUCT.GROUP,REL.CODE,OUT.ARR);*Manual R22 conversion
    APAP.REDOSRTN.redoSRepCustomerExtract(SL.CUSTOMER.ID,PRODUCT.GROUP,REL.CODE,OUT.ARR) ;*Manual R22 conversion

    YRELAT.CUST.VAL = ''
    YRELAT.CUST.VAL = RELATION.CUSTOMER.ID:"*":CUSTOMER.ID
    LOCATE YRELAT.CUST.VAL IN SEL.CONT.LST<1> SETTING REL.FM THEN
        RETURN
    END

    GOSUB GET.SL.CSPARE.VALUES

    LOCATE R.RELATION.CUSTOMER<EB.RCU.IS.RELATION,PRM.REL.INIT> IN R.FL.CUSTOMER<EB.CUS.RELATION.CODE,1> SETTING REL.INIT THEN
        GOSUB GET.EACH.ROLE.VALUES
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.SL.CSPARE.VALUES:
*********************
* In this para of the program, the variable C$SPARE is assigned with values
**
    CUS.GRP.RIESGO = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS,1>
    C$SPARE(451) = CUS.GRP.RIESGO[7]

    SL.CUS.RNC = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    IF SL.CUS.RNC THEN
        C$SPARE(452) = FMT(SL.CUS.RNC,"R(#-##-#####-#)")
    END ELSE
        C$SPARE(452) = ''
    END

    C$SPARE(453) = OUT.ARR<2>

    BEGIN CASE
        CASE R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS> NE ''
*20140319 (S)
            SL.CUS.CIDENT = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
            C$SPARE(454)  = FMT(SL.CUS.CIDENT,"R(###-#######-#)")
*20140319 (E)

        CASE R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS> NE ''
*20140319 (S)
            SL.CUS.RNC   = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
            C$SPARE(454) = FMT(SL.CUS.RNC,"R(#-##-#####-#)")
*20140319 (E)
        CASE R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS> NE ''
            C$SPARE(454) = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>

        CASE 1
            C$SPARE(454) = R.SL.CUSTOMER<EB.CUS.NATIONALITY> : R.SL.CUSTOMER<EB.CUS.LEGAL.ID,1>

    END CASE

    CUS.NAME.1 = R.SL.CUSTOMER<EB.CUS.NAME.1,LANG.CODE>
    CUS.NAME.2 = R.SL.CUSTOMER<EB.CUS.NAME.2,LANG.CODE>

    IF NOT(CUS.NAME.1) THEN
        CUS.NAME.1 = R.CUSTOMER<EB.CUS.NAME.1,1>
    END

    IF NOT(CUS.NAME.2) THEN
        CUS.NAME.2 = R.CUSTOMER<EB.CUS.NAME.2,1>
    END
    C$SPARE(455) = CUS.NAME.1 :" ": CUS.NAME.2

    C$SPARE(457) = R.FL.CUSTOMER<EB.CUS.EMPLOYMENT.STATUS,1>

    CUS.GRP.RIESGO = R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS,1>
    C$SPARE(458) = CUS.GRP.RIESGO[7]
    C$SPARE(459) = R.SL.CUSTOMER<EB.CUS.GIVEN.NAMES> : ' ' : R.SL.CUSTOMER<EB.CUS.FAMILY.NAME>
    C$SPARE(461) = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.POS.COMP.POS>
RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.EACH.ROLE.VALUES:
*********************
* In this para of the program, the ROLE values are taken
**
    ROLE.COUNT = DCOUNT(R.FL.CUSTOMER<EB.CUS.ROLE,REL.INIT>,@SM)
    ROLE.INFO.COUNT = DCOUNT(R.FL.CUSTOMER<EB.CUS.ROLE.MORE.INFO,REL.INIT>,@SM)

    IF R.FL.CUSTOMER<EB.CUS.ROLE.MORE.INFO,REL.INIT>[1,2] LE '10' THEN
        RETURN
    END

    IF ROLE.INFO.COUNT GT ROLE.COUNT THEN
        LOOP.COUNT = ROLE.INFO.COUNT
    END ELSE
        LOOP.COUNT = ROLE.COUNT
    END

    IF NOT(LOOP.COUNT) THEN
        LOOP.COUNT = 1
    END

    LOOP.INIT = 1

    LOOP
    WHILE LOOP.INIT LE LOOP.COUNT
        GOSUB GET.MAPPING.VALUES

        LOOP.INIT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------------
*******************
GET.MAPPING.VALUES:
*******************
* In this para of the program, the mapping values are taken
**
    C$SPARE(456) = R.FL.CUSTOMER<EB.CUS.ROLE.MORE.INFO,REL.INIT,LOOP.INIT>
    C$SPARE(460) = ''

    LOCATE R.FL.CUSTOMER<EB.CUS.ROLE,REL.INIT,LOOP.INIT> IN FIELD.ROLE.VAL<1> SETTING ROLE.POS THEN
        C$SPARE(460) = FIELD.ROLE.DISP<ROLE.POS>
    END
    GOSUB UPDATE.CONCAT.FILE
    GOSUB MAP.RCL.REC

RETURN
*-----------------------------------------------------------------------------------------------------------------
************
MAP.RCL.REC:
************
* In this para of the program, the CONDUIT.LINEAR values are fecthed
**
    MAP.FMT   = "MAP"
    ID.RCON.L = BATCH.DETAILS<3,1,2>
    APP       = FN.CUSTOMER
    R.APP     = R.FL.CUSTOMER
    ID.APP    = FL.CUSTOMER.ID

    CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT, ID.RCON.L, APP, ID.APP, R.APP,R.RETURN.MSG,ERR.MSG)

    FINAL.ARRAY = R.RETURN.MSG

    IF FINAL.ARRAY THEN
        GOSUB WRITE.FILE
        C$SPARE(451) = ''; C$SPARE(452) = ''; C$SPARE(453) = ''; C$SPARE(454) = ''; C$SPARE(455) = ''
        C$SPARE(456) = ''; C$SPARE(457) = ''; C$SPARE(458) = ''; C$SPARE(459) = ''; C$SPARE(460) = ''
        C$SPARE(461) = ''; C$SPARE(462) = ''
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
***********************
READ.RELATION.CUSTOMER:
***********************
* In this para of the program, file RELATION.CUSTOMER is read
**
    R.RELATION.CUSTOMER  = ''
    RELATION.CUSTOMER.ER = ''
    CALL F.READ(FN.RELATION.CUSTOMER,RELATION.CUSTOMER.ID,R.RELATION.CUSTOMER,F.RELATION.CUSTOMER,RELATION.CUSTOMER.ER)

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
READ.CUSTOMER:
**************
* In this para of the program, file CUSTOMER is read
**
    R.CUSTOMER  = ''
    CUSTOMER.ER = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)

RETURN
*-----------------------------------------------------------------------------------------------------------------
*******************
READ.CUST.DOCUMENT:
*******************
* In this para of the program, file CUST.DOCUMENT is read
**
    R.CUST.DOCUMENT  = ''
    CUST.DOCUMENT.ER = ''
    CALL F.READ(FN.CUST.DOCUMENT,CUST.DOCUMENT.ID,R.CUST.DOCUMENT,F.CUST.DOCUMENT,CUST.DOCUMENT.ER)

RETURN
*-----------------------------------------------------------------------------------------------------------------
***********
WRITE.FILE:
***********
* In this para of the program, the final array is written to the file
**
    WRITESEQ FINAL.ARRAY APPEND TO SEQ.PTR ELSE
        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP   = 04
        REC.CON  = "GR04"
        DESC     = "GR04"
*       CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*Manual R22 conversion
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
CHECK.FATAL.ERROR:
******************
* In this para of the program, the FATAL.ERROR is called
**
    MESSAGE.INFO = '' ;* Handling Fatal error to halt the process
    MESSAGE.INFO<1> = 'REDO.B.OFFICER.OF.COMPANY'
    MESSAGE.INFO<2> = CUSTOMER.ID
    MESSAGE.INFO<3> = 'BUILD.LIST'
    MESSAGE.INFO<4> = 'Record not received'
    MESSAGE.INFO<5> = 'YES'
    TEXT = ''
    CALL FATAL.ERROR(MESSAGE.INFO)

RETURN

UPDATE.CONCAT.FILE:
*******************
    GOSUB READ.REDO.GR.REP
    IF R.REDO.GR.REP.CUST THEN
        YR.REDO.GR.REP.CUST = R.REDO.GR.REP.CUST:@FM:YRELAT.CUST.VAL
    END ELSE
        YR.REDO.GR.REP.CUST = YRELAT.CUST.VAL
    END
    CALL F.WRITE(FN.REDO.GR.REP.CUST,REDO.GR.REP.CUST.ID,YR.REDO.GR.REP.CUST)
RETURN

READ.REDO.GR.REP:
*****************
    ERR.REDO.GR.REP.CUST = ''; R.REDO.GR.REP.CUST = ''; YR.REDO.GR.REP.CUST = ''
*CALL F.READ(FN.REDO.GR.REP.CUST,REDO.GR.REP.CUST.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,ERR.REDO.GR.REP.CUST)
    CALL F.READU(FN.REDO.GR.REP.CUST,REDO.GR.REP.CUST.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,ERR.REDO.GR.REP.CUST,'');* R22 AUTO CONVERSION
RETURN
END       ;*End of program
