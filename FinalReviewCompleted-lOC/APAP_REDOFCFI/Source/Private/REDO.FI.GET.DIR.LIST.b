* @ValidationCode : MjotNTY0NTQzMzpVVEYtODoxNjgzNjE2MDk0ODMyOklUU1M6LTE6LTE6NDIzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 May 2023 12:38:14
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 423
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.GET.DIR.LIST(PARAM.ID,W.ERROR)
******************************************************************************
*    Gets LIST od directories to Monitor for Incoming Files
*
* =============================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2010/Oct/20
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_REDO.FI.VARIABLES.COMMON
    $USING APAP.REDOCHNLS
*
*************************************************************************
**************************************************************************
* Modification History : *************************************************
* 29/ 03 /2011 - ODR-2010-03-0025
* Development for avoid the problems with the undesirable chars in DIR type fields
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END ELSE
        GOSUB WRITE.ERROR.IN.LOG
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
    PR.INTERF.LIST<NUM.INT>    = PARAM.ID
    PR.INTERF.MAN.DIR<NUM.INT> = MAN.DIR
    PR.INTERF.AUT.DIR<NUM.INT> = AUT.DIR
    PR.INTERF.HIS.DIR<NUM.INT> = HIS.DIR
    PR.INTERF.RUT.ID<NUM.INT>  = RUT.ID
*
RETURN

* =================
WRITE.ERROR.IN.LOG:
* =================

    BEGIN CASE

        CASE PARAM.ID EQ 'BACEN'

            FI.INT.ACT.ID = "BCN001"

        CASE PARAM.ID EQ 'ORANGE'

            FI.INT.ACT.ID = "ORG001"

        CASE PARAM.ID EQ 'INTNOMINA'

            FI.INT.ACT.ID = "INM001"

        CASE PARAM.ID EQ 'EXTNOMINA' OR PARAM.ID EQ 'EXTNOMINANOTAX'

            FI.INT.ACT.ID = "ENM001"

    END CASE

    INT.TYPE = 'BATCH'
    BAT.NO = '1'
    BAT.TOT = '1'
    INFO.OR = 'T24'
    INFO.DE = 'T24'
    ID.PROC = PARAM.ID
    MON.TP = '04'
    ID.DESC = PARAM.ID
    REC.CON = W.ERROR
    EX.USER = OPERATOR
    EX.PC = ''
*CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(FI.INT.ACT.ID,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,ID.DESC,REC.CON,EX.USER,EX.PC)
    CALL APAP.REDOCHNLS.redoInterfaceRecAct(FI.INT.ACT.ID,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,ID.DESC,REC.CON,EX.USER,EX.PC);*MANUAL R22 CODE CONVERSION

RETURN
*
* ==========================
B100.VALIDATE.DIR.EXISTANCE:
* ==========================
*
*
    GOSUB UTIL.REVIEW.LAST.CHAR

    IF MAN.DIR THEN
        OPEN MAN.DIR TO FI.WORK.DIR.POINTER ELSE
            PROCESS.GOAHEAD = 0
            W.ERROR = "EB-MISSING.DIRECTORY1 ":MAN.DIR
        END
    END
*
    IF AUT.DIR AND PROCESS.GOAHEAD THEN
        OPEN AUT.DIR TO FI.WORK.DIR.POINTER ELSE
            PROCESS.GOAHEAD = 0
            W.ERROR = "EB-MISSING.DIRECTORY2 ":AUT.DIR
        END
    END
*
    IF HIS.DIR AND PROCESS.GOAHEAD THEN
        OPEN HIS.DIR TO FI.WORK.DIR.POINTER ELSE
            PROCESS.GOAHEAD = 0
            W.ERROR = "EB-MISSING.DIRECTORY3 ":HIS.DIR
        END
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD           = 1
    LOOP.CNT                  = 1
    MAX.LOOPS                 = 4
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                CALL F.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID, R1.REDO.INTERFACE.PARAM, FV.REDO.INTERFACE.PARAM, Y.ERR)
                IF Y.ERR THEN
                    PROCESS.GOAHEAD = 0
                    W.ERROR         = "FI.PARAMETER.MISSING-&":@FM:PARAM.ID
                    CALL TXT(W.ERROR)
                END

            CASE LOOP.CNT EQ 2
                MAN.DIR = R1.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.MANUAL.PATH>
                AUT.DIR = R1.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUTO.PATH>
                HIS.DIR = R1.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.HISTORY.PATH>
                IF NOT(MAN.DIR) AND NOT(AUT.DIR) THEN
                    W.ERROR = "EB-DIRECTORIES.NOT.SPECIFIED"
                    PROCESS.GOAHEAD =0
                END

            CASE LOOP.CNT EQ 3
                RUT.ID  = R1.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.ROUTINE.NAME>
                IF NOT(RUT.ID) THEN
                    W.ERROR = "EB-ROUTINE.NOT.SPECIFIED"
                    PROCESS.GOAHEAD =0
                END

            CASE LOOP.CNT EQ 4
                GOSUB B100.VALIDATE.DIR.EXISTANCE

        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*
* =========
UTIL.REVIEW.LAST.CHAR:
* =========
*
*
    Y.LENGHT = LEN(MAN.DIR)
    Y.TEMP = Y.LENGHT - 1
    Y.POS = INDEX(MAN.DIR, '\', 1)
*IF FIND THE CHAR IN THE LAST CHARS
    IF Y.POS GT 0 THEN
        MAN.DIR = SUBSTRINGS (MAN.DIR,1, Y.TEMP)
    END


    Y.LENGHT = LEN(AUT.DIR)
    Y.TEMP = Y.LENGHT - 1
    Y.POS = INDEX(AUT.DIR, '\', 1)
*IF FIND THE CHAR IN THE LAST CHARS
    IF Y.POS GT 0 THEN
        AUT.DIR = SUBSTRINGS (AUT.DIR,1, Y.TEMP)
    END

    Y.LENGHT = LEN(HIS.DIR)
    Y.TEMP = Y.LENGHT - 1
    Y.POS = INDEX(HIS.DIR, '\', 1)
*IF FIND THE CHAR IN THE LAST CHARS
    IF Y.POS GT 0 THEN
        HIS.DIR = SUBSTRINGS (HIS.DIR,1, Y.TEMP)
    END

RETURN
*

END
