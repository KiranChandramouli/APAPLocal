<<<<<<< Updated upstream
* @ValidationCode : MjotMzI2MTMwNDY5OkNwMTI1MjoxNjkwMjY0MzU3NDM1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:22:37
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
* @ValidationCode : MjoxNDkyMjc5MTA1OkNwMTI1MjoxNjg0ODU0MzgzMTQwOklUU1M6LTE6LTE6MzUwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 350
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.COMP.OWN.RISK.GROUP(CUSTOMER.ID)
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This is an batch routine used to process the records from CUSTOMER file with required
**                        selection and generate report in the parameterized out folder
*
* Developed By          : Shiva Prasad Y, Capgemini
*
* Development Reference : 786777-REGN7-GR99
*
* Attached To           : Batch - BNK/REDO.B.COMP.OWN.RISK.GROUP
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
*                        Rashmitha M                     2014-03-18           Company Id, Company name, Doc end date
*                                                                             displayed as per the required format
*-----------------------------------------------------------------------------------------------------------------
* PACS00361958           Ashokkumar.V.P                  23/02/2015           Optimized the relation between the customer
<<<<<<< Updated upstream
* Date                   who                   Reference
=======
* Date                   who                   Reference              
>>>>>>> Stashed changes
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION SM TO @SM AND VM TO @VM AND FM TO @FM AND ! TO *
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUST.DOCUMENT
    $INSERT I_F.COMPANY
    $INSERT I_REDO.B.COMP.OWN.RISK.GROUP.COMMON
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
    YTECH.FLG = 0
    GOSUB READ.CUSTOMER
    RELATION.CUSTOMER.ID = CUSTOMER.ID
    IF NOT(R.CUSTOMER) THEN
        GOSUB RAISE.FATAL.ERROR
    END

    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS,1>) THEN
        RETURN
    END

    FL.CUSTOMER.ID       = CUSTOMER.ID

    ML.REL.CODES    = R.CUSTOMER<EB.CUS.RELATION.CODE>
    ML.REL.CUSTOMER = R.CUSTOMER<EB.CUS.REL.CUSTOMER>

    ML.REL.CODES.COUNT = DCOUNT(ML.REL.CODES,@VM)
    ML.REL.CODES.INIT  = 1

    LOOP
    WHILE ML.REL.CODES.INIT LE ML.REL.CODES.COUNT
        LOCATE ML.REL.CODES<1,ML.REL.CODES.INIT> IN SL.F.PARAM.SEL.CODES<1,1,1> SETTING ML.FOUND.POS THEN
            GOSUB CHECK.ROLE.MORE.INFO
        END
        ML.REL.CODES.INIT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
CHECK.ROLE.MORE.INFO:
*********************
* In this para of the program, the ROLE.MOE.INFO is checked to process further
**
    ROLE.FLAG = ''

    FL.ROLE.INFO.COUNT = DCOUNT(R.CUSTOMER<EB.CUS.ROLE.MORE.INFO,ML.REL.CODES.INIT>,@SM)
    FL.ROLE.INFO.INIT  = 1

    LOOP
    WHILE FL.ROLE.INFO.INIT LE FL.ROLE.INFO.COUNT
        IF R.CUSTOMER<EB.CUS.ROLE.MORE.INFO,ML.REL.CODES.INIT,FL.ROLE.INFO.INIT> GT PARAM.ROLE.INFO.VALUE THEN
            ROLE.FLAG = '1'
            FL.ROLE.INFO.INIT = FL.ROLE.INFO.COUNT
        END

        FL.ROLE.INFO.INIT += 1
    REPEAT

    IF ROLE.FLAG THEN
        GOSUB SECOND.LEVEL.FILTER
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
********************
SECOND.LEVEL.FILTER:
********************
* In this para of the program, the second level selection is executed to filter the final records to be displayed
**
    SL.CUSTOMER.ID = ML.REL.CUSTOMER<1,ML.REL.CODES.INIT>

    CUSTOMER.ID = SL.CUSTOMER.ID
    GOSUB READ.CUSTOMER

    IF NOT(R.CUSTOMER) THEN
        GOSUB RAISE.FATAL.ERROR
    END

    SL.REL.CODES    = R.CUSTOMER<EB.CUS.RELATION.CODE>
    SL.REL.CUSTOMER = R.CUSTOMER<EB.CUS.REL.CUSTOMER>

    SL.REL.CODES.COUNT = DCOUNT(SL.REL.CODES,@VM)
    SL.REL.CODES.INIT  = 1

    LOOP
    WHILE SL.REL.CODES.INIT LE SL.REL.CODES.COUNT
        LOCATE SL.REL.CODES<1,SL.REL.CODES.INIT> IN SL.S.PARAM.SEL.CODES<1,1,1> SETTING SL.FOUND.POS THEN
            GOSUB FORM.SPARE.ARRAY
        END
        SL.REL.CODES.INIT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
FORM.SPARE.ARRAY:
*****************
* In this para of the program, the CSPARE array is formed
**
    GOSUB UPDATE.CSPARE.VARIABLE

    IF YTECH.FLG EQ 1 THEN
        RETURN
    END

    CUS.ROLE.INFO.COUNT = DCOUNT(CUS.ROLE.INFO.VALUE,@SM)
    CUS.ROLE.COUNT      = DCOUNT(CUS.ROLE.VALUE,@SM)

    IF CUS.ROLE.INFO.COUNT GE CUS.ROLE.COUNT THEN
        LOOP.COUNT = CUS.ROLE.INFO.COUNT
    END ELSE
        LOOP.COUNT = CUS.ROLE.COUNT
    END

    IF NOT(LOOP.COUNT) THEN
        LOOP.COUNT = 1
    END

    LOOP.INIT = 1
    LOOP
    WHILE LOOP.INIT LE LOOP.COUNT
        GOSUB LOOP.THRU.ROLES
        LOOP.INIT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------------
***********************
UPDATE.CSPARE.VARIABLE:
***********************
* In this para of the program, the CSPARE variable is updated
**
    CUSTOMER.ID = FL.CUSTOMER.ID
    GOSUB READ.CUSTOMER

    YRELAT.CUST.VAL = ''
    YRELAT.CUST.VAL = RELATION.CUSTOMER.ID:"*":CUSTOMER.ID
    LOCATE YRELAT.CUST.VAL IN SEL.CONT.LST<1> SETTING REL.FM THEN
        YTECH.FLG = 1
        RETURN
    END

    C$SPARE(451) = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS,1>[7]
    FL.CUS.RNC   = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
*20140318 (S)
    IF FL.CUS.RNC THEN
        FL.CUS.RNC   = FMT(FL.CUS.RNC,"R(#-##-#####-#)")
        C$SPARE(452) = FL.CUS.RNC
    END ELSE
        C$SPARE(452) = ''
    END
*20140318 (E)

    CUST.DOCUMENT.ID = FL.CUSTOMER.ID:'*':PARAM.DOC.ID
    GOSUB READ.CUST.DOCUMENT

    IF NOT(R.CUST.DOCUMENT<CUS.DOC.END.DATE>) THEN
        C$SPARE(460) = ''
    END ELSE
*20140318 (S)
        Y.DOC.END.DATE=R.CUST.DOCUMENT<CUS.DOC.END.DATE>
        Y.DOC.END.DATE=ICONV(Y.DOC.END.DATE,'D')
        Y.DOC.END.DATE=OCONV(Y.DOC.END.DATE,'D4/E')
        C$SPARE(460)=Y.DOC.END.DATE
*20140318 (E)
    END

    CUS.ROLE.INFO.VALUE = R.CUSTOMER<EB.CUS.ROLE.MORE.INFO,SL.REL.CODES.INIT>
    CUS.ROLE.VALUE      = R.CUSTOMER<EB.CUS.ROLE,SL.REL.CODES.INIT>

    CUSTOMER.ID = SL.CUSTOMER.ID
    GOSUB READ.CUSTOMER

    SL.CUS.CIDENT  = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    SL.CUS.RNC     = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    SL.CUS.FOREIGN = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>

    CSPAE453 = ''

    IF SL.CUS.CIDENT THEN
*20140318 (S)
        SL.CUS.CIDENT=FMT(SL.CUS.CIDENT,"R(###-#######-#)")
*20140318 (E)
        C$SPARE(453) = SL.CUS.CIDENT
        CSPAE453     = 1
    END

    IF NOT(CSPAE453) AND SL.CUS.RNC THEN
*20140318 (S)
        SL.CUS.RNC=FMT(SL.CUS.RNC,"R(#-##-#####-#)")
*20140318 (E)
        C$SPARE(453) = SL.CUS.RNC
        CSPAE453     = 1
    END

    IF NOT(CSPAE453) AND SL.CUS.FOREIGN THEN
        C$SPARE(453) = SL.CUS.FOREIGN
        CSPAE453     = 1
    END

    IF NOT(CSPAE453) THEN
        SL.CUS.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
        SL.CUS.LEGAL  = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
        C$SPARE(453)  = SL.CUS.NATION:SL.CUS.LEGAL
    END

    CUS.NAME.1   = R.CUSTOMER<EB.CUS.NAME.1,R.COMPANY(EB.COM.LANGUAGE.CODE)>
    CUS.NAME.2   = R.CUSTOMER<EB.CUS.NAME.2,R.COMPANY(EB.COM.LANGUAGE.CODE)>
*20140318 (S)
    IF NOT(CUS.NAME.1) THEN
        CUS.NAME.1=R.CUSTOMER<EB.CUS.NAME.1,1>
    END

    IF NOT(CUS.NAME.2) THEN
        CUS.NAME.2=R.CUSTOMER<EB.CUS.NAME.2,1>
    END
*20140318 (E)
    C$SPARE(454) = CUS.NAME.1:' ':CUS.NAME.2

    SL.CUS.APAP.IND = R.CUSTOMER<EB.CUS.LOCAL.REF,L.APAP.INDUSTRY.POS>
    SL.CUS.APAP.IND = SL.CUS.APAP.IND[1,2]
    C$SPARE(455)    = SL.CUS.APAP.IND

    C$SPARE(457)    = R.CUSTOMER<EB.CUS.EMPLOYMENT.STATUS,1>

    LOCATE SL.CUS.APAP.IND IN PARAM.APAP.IND.VALUES<1,1,1> SETTING IND.FOUND.POS THEN
        C$SPARE(458) = 'S'
    END ELSE
        C$SPARE(458) = 'N'
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
****************
LOOP.THRU.ROLES:
****************
* In this para of the program, the values are looped ot display values in multiple lines, if any
**
    FINAL.ROLE.INFO = CUS.ROLE.INFO.VALUE<1,1,LOOP.INIT>
    C$SPARE(456) = FINAL.ROLE.INFO

    FINAL.ROLE   = CUS.ROLE.VALUE<1,1,LOOP.INIT>
    C$SPARE(459) = FMT(FINAL.ROLE,'R%2')

    GOSUB UPDATE.CONCAT.FILE
    GOSUB MAP.RCL.RECORD

RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
MAP.RCL.RECORD:
***************
* In this para of the program, the CONDUIT.LINEAR values are fecthed and mapped
**
    MAP.FMT   = 'MAP'
    ID.RCON.L = BATCH.DETAILS<3,1,2>
    APP       = FN.CUSTOMER
    R.APP     = R.CUSTOMER
    ID.APP    = CUSTOMER.ID

    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    OUT.ARRAY = R.RETURN.MSG

    GOSUB WRITE.TO.FILE

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
**************
WRITE.TO.FILE:
**************
* In this para of the program, the final array is written to the file
**
    WRITESEQ OUT.ARRAY APPEND TO SEQ.PTR ELSE
        ERR.MSG  = "Unable to write to file '":FILE.NAME:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'ONLINE'
        MON.TP   = 04
        REC.CON  = 'GR99-':ERR.MSG
        DESC     = 'GR99-':ERR.MSG
<<<<<<< Updated upstream
*       CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
=======
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
>>>>>>> Stashed changes
    END
    C$SPARE(451) = ''; C$SPARE(452) = ''; C$SPARE(453) = ''; C$SPARE(454) = ''; C$SPARE(455) = ''
    C$SPARE(456) = ''; C$SPARE(457) = ''; C$SPARE(458) = ''; C$SPARE(459) = ''; C$SPARE(460) = ''

RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
RAISE.FATAL.ERROR:
******************
* In this para of the program, the FATAL.ERROR is called
**
    MESSAGE.INFO = '' ;* Handling Fatal error to halt the process
    MESSAGE.INFO<1> = 'REDO.B.COMP.OWN.RISK.GROUP'
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
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
