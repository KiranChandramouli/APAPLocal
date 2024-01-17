* @ValidationCode : Mjo1MTk1MDEyMzI6Q3AxMjUyOjE3MDM1NjY1NjU5OTY6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 10:26:05
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
SUBROUTINE REDO.B.COMP.SHARE.GROUP(CUSTOMER.ID)
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN3-GR02
*
* Attached To           : Batch - BNK/REDO.B.COMP.SHARE.GROUP
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
* REGN3-GR02             Kalyani L K                     2014-02-19           Initial Draft
* Date                   who                   Reference
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION I_COMMON TO I_TSA.COMMON AND VM TO @VM AND FM TO @FM AND SM TO @SM AND ++ TO += 1 AND SESSION.NO TO AGENT.NUMBER
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023            Suresh             R22 Manual Conversion -Change F.READ to F.READU
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_TSA.COMMON 	;*R22 AUTO CONVERSION ADDED I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUST.DOCUMENT
    $INSERT I_F.COMPANY
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.COMP.SHARE.GROUP.COMMON
    $USING APAP.REDOCHNLS
    $USING APAP.REDOSRTN
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
    FL.CUS.RNC       = R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>

    IF FL.CUS.RNC THEN
        C$SPARE(452) = FMT(FL.CUS.RNC,"R(#-##-#####-#)")
    END ELSE
        C$SPARE(452) = ''
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------
********************
GET.SL.DOC.LAST.PAY:
********************
    CUST.DOCUMENT.ID = SL.CUSTOMER.ID :'*': FIELD.DOC.VAL
    GOSUB READ.CUST.DOCUMENT

    IF NOT(R.CUST.DOCUMENT<CUS.DOC.SIG.DATE>) THEN
        C$SPARE(462) = ''
    END ELSE
        Y.DOC.END.DATE = R.CUST.DOCUMENT<CUS.DOC.SIG.DATE>
        Y.DOC.END.DATE = ICONV(Y.DOC.END.DATE,'D')
        Y.DOC.END.DATE = OCONV(Y.DOC.END.DATE,'D4/E')
        C$SPARE(462)   = Y.DOC.END.DATE
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
CHECK.RELATION.CODES:
*********************
* In this para of the program, the relation codes defined for Customer are checked
**
    C$SPARE(463) = ''
    PRM.REL.COUNT = DCOUNT(R.RELATION.CUSTOMER<EB.RCU.IS.RELATION>,@VM)
    PRM.REL.INIT  = 1
    LOOP
    WHILE PRM.REL.INIT LE PRM.REL.COUNT
        LOCATE R.RELATION.CUSTOMER<EB.RCU.IS.RELATION,PRM.REL.INIT> IN FIELD.REV.VAL<1> SETTING REL.CODE.POS THEN
            SL.CUSTOMER.ID  = R.RELATION.CUSTOMER<EB.RCU.OF.CUSTOMER,PRM.REL.INIT>
            CUSTOMER.ID     = SL.CUSTOMER.ID
            GOSUB READ.CUSTOMER
            R.SL.CUSTOMER   = R.CUSTOMER
            IF R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'PERSONA FISICA' THEN
                C$SPARE(463)='P'
            END
            IF R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
                IF NOT(C$SPARE(463)) THEN
                    C$SPARE(463)='E'
                END
            END
        END
        PRM.REL.INIT += 1
    REPEAT

    PRM.REL.INIT  = 1
    LOOP
    WHILE PRM.REL.INIT LE PRM.REL.COUNT
        LOCATE R.RELATION.CUSTOMER<EB.RCU.IS.RELATION,PRM.REL.INIT> IN FIELD.REV.VAL<1> SETTING REL.CODE.POS THEN
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
    CUSTOMER.ID   = SL.CUSTOMER.ID
    GOSUB READ.CUSTOMER

    R.SL.CUSTOMER = R.CUSTOMER

    PRODUCT.GROUP = ''
    REL.CODE      = ''
*    CALL REDO.S.REP.CUSTOMER.EXTRACT(SL.CUSTOMER.ID,PRODUCT.GROUP,REL.CODE,OUT.ARR)
    APAP.REDOSRTN.redoSRepCustomerExtract(SL.CUSTOMER.ID,PRODUCT.GROUP,REL.CODE,OUT.ARR) ;*R22 Manual Code Conversion

    GOSUB GET.SL.CSPARE.VALUES
    GOSUB GET.SL.DOC.LAST.PAY

    Y.SL.REL.CODES       = R.SL.CUSTOMER<EB.CUS.RELATION.CODE>
    Y.SL.REL.CUSTOMER    = R.SL.CUSTOMER<EB.CUS.REL.CUSTOMER>
    Y.SL.REL.CODES.COUNT = DCOUNT(Y.SL.REL.CODES,@VM)
    Y.SL.REL.CODES.INIT  = 1
    LOOP
    WHILE Y.SL.REL.CODES.INIT LE Y.SL.REL.CODES.COUNT
        LOCATE Y.SL.REL.CODES<1,Y.SL.REL.CODES.INIT> IN FIELD.REL.VAL SETTING Y.SLR.CUST.POS THEN
            IF Y.SL.REL.CUSTOMER<1,Y.SL.REL.CODES.INIT> EQ FL.CUSTOMER.ID THEN
                GOSUB CHECK.REPT.REQ
                IF Y.REP.REQ THEN
                    CUS.ROLE.INFO.VALUE = R.SL.CUSTOMER<EB.CUS.ROLE.MORE.INFO,Y.SL.REL.CODES.INIT>
                    CUS.ROLE.VALUE      = R.SL.CUSTOMER<EB.CUS.ROLE,Y.SL.REL.CODES.INIT>
                    GOSUB GET.EACH.ROLE.VALUES
                END
            END
        END
        Y.SL.REL.CODES.INIT += 1
    REPEAT
RETURN
****************
CHECK.REPT.REQ:
****************

    Y.REP.REQ=''
    Y.REP.FR.FL=''
    Y.REL.REP=FL.CUSTOMER.ID:'*':SL.CUSTOMER.ID
    LOCATE Y.REL.REP IN Y.GR02.REP.LIST SETTING Y.GR02.REP.POS ELSE
        Y.REP.REQ  ='Y'
        Y.REP.FR.FL='Y'
    END
    IF NOT(Y.REP.REQ) THEN
        LOCATE FL.CUSTOMER.ID IN Y.GR01.REP.LIST SETTING Y.GR01.REP.POS THEN
            Y.REP.REQ='Y'
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.SL.CSPARE.VALUES:
*********************
* In this para of the program, the variable C$SPARE is assigned with values
**
    C$SPARE(453) = OUT.ARR<2>

    C$SPARE(454) = ''

    BEGIN CASE
        CASE R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS> NE ''
            SL.CUS.CIDENT = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
            C$SPARE(454)  = FMT(SL.CUS.CIDENT,"R(###-#######-#)")

        CASE R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS> NE ''
            SL.CUS.RNC   = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
            C$SPARE(454) = FMT(SL.CUS.RNC,"R(#-##-#####-#)")

        CASE R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS> NE ''
            C$SPARE(454) = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>

        CASE 1
            C$SPARE(454) = R.SL.CUSTOMER<EB.CUS.NATIONALITY> : R.SL.CUSTOMER<EB.CUS.LEGAL.ID,1>

    END CASE

    C$SPARE(455) = ''


    IF R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'PERSONA FISICA' THEN
        C$SPARE(455) = R.SL.CUSTOMER<EB.CUS.GIVEN.NAMES> :' ': R.SL.CUSTOMER<EB.CUS.FAMILY.NAME>
    END

    LANG.CODE = R.COMPANY(EB.COM.LANGUAGE.CODE)

    IF R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
        SL.CUS.NAME.1 = R.SL.CUSTOMER<EB.CUS.NAME.1,LANG.CODE>
        SL.CUS.NAME.2 = R.SL.CUSTOMER<EB.CUS.NAME.2,LANG.CODE>

        IF NOT(SL.CUS.NAME.1) THEN
            SL.CUS.NAME.1 = R.SL.CUSTOMER<EB.CUS.NAME.1,1>
        END

        IF NOT(SL.CUS.NAME.2) THEN
            SL.CUS.NAME.2 = R.SL.CUSTOMER<EB.CUS.NAME.2,1>
        END

        C$SPARE(455) = SL.CUS.NAME.1 :' ': SL.CUS.NAME.2
    END

    C$SPARE(458) = ''
    C$SPARE(459) = ''

    C$SPARE(457)  = R.SL.CUSTOMER<EB.CUS.EMPLOYMENT.STATUS,1>

    CALL F.READ(FN.RELATION.CUSTOMER,SL.CUSTOMER.ID,R.SL.REL.CUSTOMER,F.RELATION.CUSTOMER,RELATION.CUSTOMER.ER)

    LOCATE FIELD.LEGAL.VAL IN R.SL.REL.CUSTOMER<EB.RCU.IS.RELATION,1> SETTING SFL.POS THEN
        GOSUB GET.SFL.VALUE
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
GET.SFL.VALUE:
**************
* In this para of the program, the details of relation customer for 104 code is taken
**
    SFL.CUSTOMER.ID = R.SL.REL.CUSTOMER<EB.RCU.OF.CUSTOMER,SFL.POS>

    CUSTOMER.ID = SFL.CUSTOMER.ID
    GOSUB READ.CUSTOMER

    R.SFL.CUSTOMER = R.CUSTOMER

    BEGIN CASE
        CASE R.SFL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS> NE ''
            SFL.CUS.CIDENT = R.SFL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
            C$SPARE(458)   = FMT(SFL.CUS.CIDENT,"R(###-#######-#)")

        CASE R.SFL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS> NE ''
            SFL.CUS.RNC  = R.SFL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
            C$SPARE(458) = FMT(SFL.CUS.RNC,"R(#-##-#####-#)")

        CASE R.SFL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS> NE ''
            C$SPARE(458) = R.SFL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>

        CASE 1
            C$SPARE(458) = R.SFL.CUSTOMER<EB.CUS.NATIONALITY> : R.SFL.CUSTOMER<EB.CUS.LEGAL.ID,1>

    END CASE

    C$SPARE(459) = R.SFL.CUSTOMER<EB.CUS.GIVEN.NAMES> : ' ' : R.SFL.CUSTOMER<EB.CUS.FAMILY.NAME>

RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.EACH.ROLE.VALUES:
*********************
* In this para of the program, the ROLE values are taken
**
    ROLE.COUNT      = DCOUNT(CUS.ROLE.VALUE,@SM)
    ROLE.INFO.COUNT = DCOUNT(CUS.ROLE.INFO.VALUE,@SM)

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
    IF CUS.ROLE.INFO.VALUE<1,1,LOOP.INIT> GT 10 THEN
        C$SPARE(456) = CUS.ROLE.INFO.VALUE<1,1,LOOP.INIT>
        C$SPARE(460) = ''
        C$SPARE(461) = ''
        LOCATE CUS.ROLE.VALUE<1,1,LOOP.INIT> IN FIELD.ROLE.VAL<1> SETTING ROLE.POS THEN
            C$SPARE(460) = FIELD.ROLE.DISP<ROLE.POS>
        END ELSE
            CUST.ROLE    = CUS.ROLE.VALUE<1,1,LOOP.INIT>
            C$SPARE(461) = FMT(CUST.ROLE,'R%2')
        END

        Y.RGRC.ID='GR02':TODAY:AGENT.NUMBER  ;*R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER
*        CALL F.READ(FN.REDO.GR.REP.CUST,Y.RGRC.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.RGRC.ERR)
        CALL F.READU(FN.REDO.GR.REP.CUST,Y.RGRC.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.RGRC.ERR,"") ;*R22 Manual Conversion
        IF Y.REP.FR.FL THEN
            R.REDO.GR.REP.CUST<-1>=FL.CUSTOMER.ID:'*':SL.CUSTOMER.ID
            CALL F.WRITE(FN.REDO.GR.REP.CUST,Y.RGRC.ID,R.REDO.GR.REP.CUST)
        END

        REDO.RISK.GROUP.IDS = R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS>
        CHANGE @SM TO @FM IN REDO.RISK.GROUP.IDS
        Y.RISK.GROUP.TOT=DCOUNT(REDO.RISK.GROUP.IDS,@FM)
        GOSUB CHECK.REPT.REQ
        Y.RISK.GROUP.CNT=1
        LOOP
        WHILE Y.RISK.GROUP.CNT LE Y.RISK.GROUP.TOT
            REDO.RISK.GROUP.ID = REDO.RISK.GROUP.IDS<Y.RISK.GROUP.CNT>
            C$SPARE(451) = REDO.RISK.GROUP.ID[7]
            GOSUB MAP.RCL.REC
            Y.RISK.GROUP.CNT += 1
        REPEAT
    END
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
        REC.CON  = "GR02"
        DESC     = "GR02"
*       CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
CHECK.FATAL.ERROR:
******************
* In this para of the program, the FATAL.ERROR is called
**
    MESSAGE.INFO = '' ;* Handling Fatal error to halt the process
    MESSAGE.INFO<1> = 'REDO.B.COMP.SHARE.GROUP'
    MESSAGE.INFO<2> = CUSTOMER.ID
    MESSAGE.INFO<3> = 'BUILD.LIST'
    MESSAGE.INFO<4> = 'Record not received'
    MESSAGE.INFO<5> = 'YES'
    TEXT = ''
    CALL FATAL.ERROR(MESSAGE.INFO)

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
