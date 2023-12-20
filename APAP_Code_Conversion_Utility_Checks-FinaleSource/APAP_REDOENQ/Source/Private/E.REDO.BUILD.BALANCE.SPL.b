* @ValidationCode : MjoxOTU4MzU4NTk4OkNwMTI1MjoxNjgyMDczMzc5Mjk4OklUU1M6LTE6LTE6MzMyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 332
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE E.REDO.BUILD.BALANCE.SPL(ENQ.DATA)
*
* =============================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.NV.E.BALANCE
* Attached as     : BUILD.ROUTINE
* Primary Purpose :
*
*=======================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011 - MAY - 13
**-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                 REFERENCE                 DESCRIPTION
* 17-APR-2023     Conversion tool   R22 Auto conversion         VM to @VM, IF Condition added
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*=======================================================================
*
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID
    $INSERT I_System
*
    $INSERT I_REDO.NV.COMMON

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*--------
PROCESS:
*--------
*
    WFOUND = ""
*
    LOOP
        REMOVE WTT.ID FROM TELLER.NO SETTING TELLER.POS
    WHILE WTT.ID:TELLER.POS AND NOT(WFOUND) DO
        CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
        IF R.TELLER.ID THEN
            GOSUB CHECK.OPEN
        END
    REPEAT
*
RETURN
*

CHECK.OPEN:

    IF R.TELLER.ID<TT.TID.STATUS> EQ "OPEN" THEN
        WTT.ID = System.getVariable("CURRENT.INDA.ID")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
            WTT.ID = ""
        END					;*R22 Auto conversion - END
        IF WTT.ID EQ 'CURRENT.INDA.ID' THEN
            WTT.ID = System.getVariable("CURRENT.WTM.FIRST.ID")
            IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
                WTT.ID = ""
            END					;*R22 Auto conversion - END
            IF WTT.ID EQ 'CURRENT.WTM.FIRST.ID' THEN
                RETURN
            END
        END


        IF WTT.ID[1,7] NE 'CURRENT' THEN
            R.REDO.STORE.SPOOL.ID = '' ; SPLERR = ''
            CALL F.READ(FN.REDO.STORE.SPOOL.ID,WTT.ID,R.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID,SPLERR)
            IF R.REDO.STORE.SPOOL.ID THEN
                R.REDO.STORE.SPOOL.ID = CHANGE(R.REDO.STORE.SPOOL.ID,@VM,' ')
                ENQ.DATA<4,1> = R.REDO.STORE.SPOOL.ID
                WFOUND = 1
            END
        END
    END

RETURN
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
    IF Y.ERR.MSG THEN
        ETEXT           = Y.ERR.MSG
        CALL STORE.END.ERROR
        ETEXT           = ""
    END
*
RETURN
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD    = 1
    Y.ERR.MSG          = ""
*
    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""
*
    FN.TELLER.USER = "F.TELLER.USER"
    F.TELLER.USER  = ""

    FN.REDO.STORE.SPOOL.ID = 'F.REDO.STORE.SPOOL.ID'
    F.REDO.STORE.SPOOL.ID = ''
    CALL OPF(FN.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID)


    Y.APPL = 'TELLER.ID'
    Y.FLD = 'L.INITIAL.ID'
    Y.POSS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FLD,Y.POSS)
    Y.PS.INI.ID = Y.POSS<1,1>

*
    ENQ.DATA<2,1>   = "@ID"
    ENQ.DATA<3,1>   = "EQ"
*
    IF ENQ.DATA<4,1> NE "" THEN
        PROCESS.GOAHEAD = ""
    END
*
RETURN
*
*---------------
OPEN.FILES:
*---------------
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1

                CALL F.READ(FN.TELLER.USER,OPERATOR,R.TELLER.USER,F.TELLER.USER,ERR.MSJ)
                IF R.TELLER.USER THEN
                    TELLER.NO  = R.TELLER.USER
                END ELSE
                    Y.ERR.MSG = "EB-NOTELLER.ASSIGNED"
                    AF = TT.TE.AMOUNT.LOCAL.1
                    PROCESS.GOAHEAD = 0
                END

        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
