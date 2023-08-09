<<<<<<< Updated upstream
* @ValidationCode : MjoyMTExNjIwMzg0OkNwMTI1MjoxNjkwMjY0Mzk1MjEyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:23:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
* @ValidationCode : MjotNjExNjc4MTQzOkNwMTI1MjoxNjg0ODU0Mzg5MDM5OklUU1M6LTE6LTE6Mjc2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 276
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LINKS.CONSANGUINITY(CUSTOMER.ID)
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN6-GR05
*
* Attached To           : Batch - BNK/REDO.B.LINKS.CONSANGUINITY
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
* REGN6-GR05             Kalyani L K                     2014-02-18           Initial Draft
*                        Rashmitha M                     2014-03-19           Company name and cident displayed
*                                                                             as per the format
* PACS00361957           Ashokkumar.V.P                  19/02/2015           Optimized the relation between the customer
<<<<<<< Updated upstream
* Date                   who                   Reference
=======
* Date                   who                   Reference              
>>>>>>> Stashed changes
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND ! TO *
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.LINKS.CONSANGUINITY.COMMON
<<<<<<< Updated upstream
    $USING APAP.REDOCHNLS
=======
>>>>>>> Stashed changes
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
    C$SPARE(451) = ''

    BEGIN CASE
        CASE R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS> NE ''
*20140319 (S)
            FL.CUS.CIDENT=R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
            FL.CUS.CIDENT= FMT(FL.CUS.CIDENT,"R(###-#######-#)")
            C$SPARE(451) = FL.CUS.CIDENT
*20140319 (E)
        CASE 1
            C$SPARE(451) = R.FL.CUSTOMER<EB.CUS.NATIONALITY> : R.FL.CUSTOMER<EB.CUS.LEGAL.ID,1>

    END CASE

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

    YRELAT.CUST.VAL = ''
    YRELAT.CUST.VAL = RELATION.CUSTOMER.ID:"*":CUSTOMER.ID
    LOCATE YRELAT.CUST.VAL IN SEL.CONT.LST<1> SETTING REL.FM THEN
        RETURN
    END

    GOSUB GET.SL.CSPARE.VALUES
    GOSUB UPDATE.CONCAT.FILE
RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.SL.CSPARE.VALUES:
*********************
* In this para of the program, the variable C$SPARE is assigned with values
**
    C$SPARE(452) = ''

    BEGIN CASE
        CASE R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS> NE ''
*20140319 (S)
            SL.CUS.CIDENT=R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
            SL.CUS.CIDENT=FMT(SL.CUS.CIDENT,"R(###-#######-#)")
            C$SPARE(452) =SL.CUS.CIDENT
*20140319 (E)
        CASE 1
            C$SPARE(452) = R.SL.CUSTOMER<EB.CUS.NATIONALITY> : R.SL.CUSTOMER<EB.CUS.LEGAL.ID,1>
    END CASE

    IF R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'PERSONA FISICA' THEN
        C$SPARE(453) = R.SL.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.SL.CUSTOMER<EB.CUS.FAMILY.NAME>
    END

    LANG.CODE = R.COMPANY(EB.COM.LANGUAGE.CODE)

    IF R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
*20140319 (S)
        CUS.NAME.1=R.SL.CUSTOMER<EB.CUS.NAME.1,LANG.CODE>
        CUS.NAME.2=R.SL.CUSTOMER<EB.CUS.NAME.2,LANG.CODE>
        IF NOT(CUS.NAME.1) THEN
            CUS.NAME.1=R.CUSTOMER<EB.CUS.NAME.1,1>
        END

        IF NOT(CUS.NAME.2) THEN
            CUS.NAME.2=R.CUSTOMER<EB.CUS.NAME.2,1>
        END
        C$SPARE(453) = CUS.NAME.1 :' ': CUS.NAME.2
*20140319 (E)
    END

    REL.DISP.VAL = FIELD.REL.DISP<REL.CODE.POS>
    REL.DISP.M   = FIELD(REL.DISP.VAL,'-',1,1)
    REL.DISP.F   = FIELD(REL.DISP.VAL,'-',2,1)

    C$SPARE(454) = ''

    BEGIN CASE
        CASE R.SL.CUSTOMER<EB.CUS.GENDER> EQ 'MALE'
            C$SPARE(454) = REL.DISP.M[1,2]

        CASE R.SL.CUSTOMER<EB.CUS.GENDER> EQ 'FEMALE'
            C$SPARE(454) = REL.DISP.F[1,2]

    END CASE

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
***********
WRITE.FILE:
***********
* In this para of the program, the final array is written to the file
**
    WRITESEQ FINAL.ARRAY APPEND TO SEQ.PTR ELSE
        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP   = 04
        REC.CON  = "GR05"
        DESC     = "GR05"
<<<<<<< Updated upstream
*       CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
=======
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
>>>>>>> Stashed changes
    END
RETURN

******************
CHECK.FATAL.ERROR:
******************
* In this para of the program, the FATAL.ERROR is called
**
    MESSAGE.INFO = '' ;* Handling Fatal error to halt the process
    MESSAGE.INFO<1> = 'REDO.B.LINKS.CONSANGUINITY'
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
    CALL F.READ(FN.REDO.GR.REP.CUST,REDO.GR.REP.CUST.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,ERR.REDO.GR.REP.CUST)
RETURN
END       ;*End of program
