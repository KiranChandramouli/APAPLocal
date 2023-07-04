* @ValidationCode : MjotMjA4MzEwOTczNTpDcDEyNTI6MTY4MTEzNTE2NDUyNjpJVFNTOi0xOi0xOjQwOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 19:29:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 40
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.IN.MSG(Y.IN.MSG)

    $INSERT I_EQUATE
    $INSERT I_COMMON
*
    $INSERT I_F.REDO.INTERFACE.PARAM
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
* ---------------------------------------------------------------
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ---------------------------------------------------------------------
*
*             P  R  O  C  E  S  O
*
* ---------------------------------------------------------------------
*
* ======
PROCESS:
* ======
*
    Y.IN.MSG = "CLEARING,," : AEP.SIGNON : "," : AEP : "," : Y.IN.MSG
*
RETURN
*
* ---------------------------------------------------------------
*
*                      I N I T I A L I S E
*
* ---------------------------------------------------------------
*
* ---------
INITIALISE:
* ---------
*
*--- INITIALIZES VARIABLES  ---*
*
    PROCESS.GOAHEAD = 1
    LOOP.CNT        = 1
    MAX.LOOPS       = 2
*
    F.REDO.INTERFACE.PARAM  = ""
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
*
    AEP = FIELD(Y.IN.MSG,"|",8)
    AEP = FIELD(AEP,".",1)
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
* OPENS THE REQUIRED TABLES
*
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
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
                CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, AEP, R.REDO.INTERFACE.PARAM, Y.ERR)
                IF Y.ERR THEN
                    PROCESS.GOAHEAD = 0
                    E = "EB-PARAMETER.MISSING"
                    CALL ERR
                END

            CASE LOOP.CNT EQ 2
                RIP.USER     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.USER.SIGN.ON>
                RIP.PASSWORD = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.USER.PWD>
                AEP.SIGNON   = RIP.USER : "/" : RIP.PASSWORD

        END CASE
        LOOP.CNT +=1
    REPEAT
*
RETURN
*
END
