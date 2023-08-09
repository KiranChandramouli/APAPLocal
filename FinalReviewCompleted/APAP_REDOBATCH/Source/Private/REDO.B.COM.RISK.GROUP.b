<<<<<<< Updated upstream
* @ValidationCode : MjotNTg3MDc5MjY1OkNwMTI1MjoxNjkwMjY0MzU3MTk2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
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
* @ValidationCode : MjoxNTQ0MzY2MTcwOkNwMTI1MjoxNjg0ODU0MzgyNzQwOklUU1M6LTE6LTE6NDY4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 468
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.COM.RISK.GROUP(CUSTOMER.ID)
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Thenmalar T, Capgemini
*
* Development Reference : REGN3-GR01
*
* Attached To           : Batch - BNK/REDO.B.COM.RISK.GROUP
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
* REGN3-GR01             Thenmalar T                     2014-02-20           Initial Draft
*                        Thenmalar T                     2014-03-18           Fixes done as per the changes suggested
* Date                   who                   Reference
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM AND SM TO @SM AND ++ TO += 1 AND ! TO * AND I_COMMON TO I_TSA.COMMON AND COMMITTED THE I_F.COMPANY AND SESSION.NO TO AGENT.NUMBER
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_TSA.COMMON  ;*R22 AUTO CONVERSTION added I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUST.DOCUMENT
*   $INSERT I_F.COMPANY     ;*R22 AUTO CONVERSTION COMMENTED THE I_F.COMPANY
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.COM.RISK.GROUP.COMMON
    $INSERT I_F.REDO.RISK.GROUP
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_BATCH.FILES
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

    C$SPARE(451) =''
    C$SPARE(452) =''
    C$SPARE(453) =''
    C$SPARE(454) =''
    C$SPARE(455) =''
    C$SPARE(456) =''
    C$SPARE(457) =''
    C$SPARE(458) =''
    C$SPARE(459) =''

    GOSUB READ.CUSTOMER

    IF NOT(R.CUSTOMER) THEN
        GOSUB CHECK.FATAL.ERROR
    END

    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS>) THEN
        RETURN
    END
    FL.CUSTOMER.ID = CUSTOMER.ID
    R.FL.CUSTOMER  = R.CUSTOMER

    LANG.CODE = R.COMPANY(EB.COM.LANGUAGE.CODE)

    GOSUB GET.CSPARE.VALUES

RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
GET.CSPARE.VALUES:
******************
* In this para of the program, the CSPARE values are assigned
**
    Y.CU.RNC = R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    IF Y.CU.RNC NE '' THEN
        Y.CU.RNC.VAL = FMT(Y.CU.RNC,"R(#-##-#####-#)")
    END ELSE
        Y.CU.RNC.VAL = ''
    END

    C$SPARE(453) = Y.CU.RNC.VAL
*20140318(E)

*20140317(S)

    IF R.FL.CUSTOMER<EB.CUS.NAME.1,LANG.CODE> EQ '' THEN
        Y.NAME.1 = R.FL.CUSTOMER<EB.CUS.NAME.1>
    END ELSE
        Y.NAME.1 = R.FL.CUSTOMER<EB.CUS.NAME.1,LANG.CODE>
    END

    IF R.FL.CUSTOMER<EB.CUS.NAME.2,LANG.CODE> EQ '' THEN
        Y.NAME.2 = R.FL.CUSTOMER<EB.CUS.NAME.2>
    END ELSE
        Y.NAME.2 = R.FL.CUSTOMER<EB.CUS.NAME.2,LANG.CODE>
    END
    GOSUB GET.CSPARE.VAL.TWO
RETURN
*******************
GET.CSPARE.VAL.TWO:
*******************

    Y.LANG.NAME = Y.NAME.1:' ':Y.NAME.2

    C$SPARE(454) = Y.LANG.NAME
*20140317(E)

    APAP.IND.VAL = R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.APAP.INDUSTRY.POS,1>[1,2]
    C$SPARE(455) = APAP.IND.VAL

    C$SPARE(456) = R.FL.CUSTOMER<EB.CUS.EMPLOYMENT.STATUS,1>

    LOCATE APAP.IND.VAL IN FIELD.IND.VAL<1> SETTING IND.POS THEN
        C$SPARE(457) = FIELD.IND.DISP<IND.POS>
    END ELSE
        C$SPARE(457) = 'N'
    END

    CUST.DOCUMENT.ID = CUSTOMER.ID :'*': FIELD.DOC.VAL
    GOSUB READ.CUST.DOCUMENT

    IF NOT(R.CUST.DOCUMENT<CUS.DOC.SIG.DATE>) THEN
        C$SPARE(458) = ''
    END ELSE
        C$SPARE(458) = R.CUST.DOCUMENT<CUS.DOC.SIG.DATE>
    END

    GOSUB GET.RELATION.CUSTOMER.DETS

RETURN
*-----------------------------------------------------------------------------------------------------------------
***************************
GET.RELATION.CUSTOMER.DETS:
***************************
* In this para of the program, the details of relation customer is taken
**
    Y.REP.REQ    =''
    Y.VALID.SH.EX=''
    CALL F.READ(FN.RELATION.CUSTOMER,CUSTOMER.ID,R.REL.CUSTOMER,F.RELATION.CUSTOMER,ERR)
    REL.COUNT = DCOUNT(R.REL.CUSTOMER<EB.RCU.OF.CUSTOMER>,@VM)
    REL.INIT  = 1

    LOOP
    WHILE REL.INIT LE REL.COUNT
        SL.CUSTOMER.ID = R.REL.CUSTOMER<EB.RCU.OF.CUSTOMER,REL.INIT>
        CUSTOMER.ID = SL.CUSTOMER.ID
        GOSUB READ.CUSTOMER
        R.SL.CUSTOMER = R.CUSTOMER
        GOSUB GET.REL.CUSTOMER.VAL
        REL.INIT += 1
    REPEAT

    IF Y.VALID.SH.EX THEN

        REDO.RISK.GROUP.IDS = R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS>
        CHANGE @SM TO @FM IN REDO.RISK.GROUP.IDS
        Y.RISK.GROUP.TOT=DCOUNT(REDO.RISK.GROUP.IDS,@FM)
        GOSUB CHECK.REPT.REQ
        IF NOT(Y.REP.REQ) AND NOT(Y.REP.RG.REQ) THEN
            RETURN
        END
        Y.RGRC.ID='GR01':TODAY:AGENT.NUMBER ;*R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER
        CALL F.READ(FN.REDO.GR.REP.CUST,Y.RGRC.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.RGRC.ERR)
        R.REDO.GR.REP.CUST<-1>=Y.GR01.RG.LIST
        CALL F.WRITE(FN.REDO.GR.REP.CUST,Y.RGRC.ID,R.REDO.GR.REP.CUST)
        Y.RISK.GROUP.CNT=1
        LOOP
        WHILE Y.RISK.GROUP.CNT LE Y.RISK.GROUP.TOT
            REDO.RISK.GROUP.ID = REDO.RISK.GROUP.IDS<Y.RISK.GROUP.CNT>
            GOSUB READ.REDO.RISK.GROUP
            C$SPARE(451) = REDO.RISK.GROUP.ID[7]
            Y.DESC = R.REDO.RISK.GROUP<RG.RISK.GRP.DESC>
            CHANGE @VM TO '' IN Y.DESC
            C$SPARE(452) = Y.DESC
            GOSUB MAP.RCL.REC
            Y.RISK.GROUP.CNT += 1
        REPEAT
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.REL.CUSTOMER.VAL:
*********************
* In this para of the program, the relation customer value is checked
**
    CUS.TIPO.CL = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>

    Y.SL.CORP.LIST    =R.SL.CUSTOMER<EB.CUS.REL.CUSTOMER>
    Y.SL.REL.CODE.LIST=R.SL.CUSTOMER<EB.CUS.RELATION.CODE>
    Y.SL.LOOP.CNT=1
    Y.SL.LOOP.TOT=DCOUNT(Y.SL.CORP.LIST,@VM)
    LOOP
    WHILE Y.SL.LOOP.CNT LE Y.SL.LOOP.TOT
        IF Y.SL.CORP.LIST<1,Y.SL.LOOP.CNT> EQ FL.CUSTOMER.ID THEN
            LOCATE Y.SL.REL.CODE.LIST<1,Y.SL.LOOP.CNT> IN Y.REL.CODE.LIST SETTING Y.SL.REL.POSN THEN
                Y.SH.PERCENT=R.SL.CUSTOMER<EB.CUS.ROLE.MORE.INFO>
                IF Y.SH.PERCENT GT 10 THEN
                    IF CUS.TIPO.CL EQ 'PERSONA JURIDICA' THEN
                        IF NOT(C$SPARE(459)) THEN
                            C$SPARE(459) = 'E'
                        END
                    END ELSE
                        C$SPARE(459) = 'P'
                    END
                    Y.VALID.SH.EX='1'
                    GOSUB CHECK.GR02.REP
                END
            END
        END
        Y.SL.LOOP.CNT += 1
    REPEAT
RETURN

****************
CHECK.REPT.REQ:
****************

    Y.REP.RG.REQ=''
    Y.RISK.GROUP.CNT=1
    LOOP
    WHILE Y.RISK.GROUP.CNT LE Y.RISK.GROUP.TOT
        REDO.RISK.GROUP.ID = REDO.RISK.GROUP.IDS<Y.RISK.GROUP.CNT>
        Y.CHK.REP.ID       = FL.CUSTOMER.ID:'*':REDO.RISK.GROUP.ID
        LOCATE Y.CHK.REP.ID IN Y.GR01.REP.LIST SETTING Y.GR01.REP.POS ELSE
            Y.REP.RG.REQ='Y'
            Y.GR01.RG.LIST<-1>=Y.CHK.REP.ID
        END
        Y.RISK.GROUP.CNT += 1
    REPEAT
RETURN
***************
CHECK.GR02.REP:
***************

    IF NOT(Y.REP.REQ) THEN
        Y.ALD.REP.ID       = FL.CUSTOMER.ID:'*':SL.CUSTOMER.ID
        LOCATE Y.ALD.REP.ID IN Y.GR02.REP.LIST SETTING Y.GR01.REP.POS ELSE
            Y.REP.REQ='Y'
        END
    END
RETURN
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

    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)

    FINAL.ARRAY = R.RETURN.MSG

    IF FINAL.ARRAY THEN
        GOSUB WRITE.FILE
    END

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
*********************
READ.REDO.RISK.GROUP:
*********************
* In this para of the program, file REDO.RISK.GROUP is read
**
    R.REDO.RISK.GROUP  = ''
    REDO.RISK.GROUP.ER = ''
    CALL F.READ(FN.REDO.RISK.GROUP,REDO.RISK.GROUP.ID,R.REDO.RISK.GROUP,F.REDO.RISK.GROUP,REDO.RISK.GROUP.ER)

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
        REC.CON  = "GR01"
        DESC     = "GR01"
<<<<<<< Updated upstream
*       CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
=======
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
>>>>>>> Stashed changes
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
CHECK.FATAL.ERROR:
******************
* In this para of the program, the FATAL.ERROR is called
**
    MESSAGE.INFO    = ''        ;* Handling Fatal error to halt the process
    MESSAGE.INFO<1> = 'REDO.B.COM.RISK.GROUP'
    MESSAGE.INFO<2> = CUSTOMER.ID
    MESSAGE.INFO<3> = 'BUILD.LIST'
    MESSAGE.INFO<4> = 'Record not received'
    MESSAGE.INFO<5> = 'YES'
    TEXT = ''
    CALL FATAL.ERROR(MESSAGE.INFO)

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
