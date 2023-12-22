* @ValidationCode : MjotMTczMTY4MzYzNzpVVEYtODoxNzAzMDc1ODA0MjQxOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Dec 2023 18:06:44
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE E.REDO.BUILD.BALANCE(ENQ.DATA)
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
*
* 18-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 20-12-2023      Narmadha V        Manual R22 Conversion      CALL OPF added
*=======================================================================
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

*  *   DEBUG


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
            IF R.TELLER.ID<TT.TID.STATUS> EQ "OPEN" THEN
                Y.INITIAL.ID = R.TELLER.ID<TT.TID.LOCAL.REF,Y.PS.INI.ID>
                IF Y.INITIAL.ID NE '' THEN
                    ENQ.DATA<4,1> = WTT.ID
                    WFOUND = 1
                END
            END
        END
    REPEAT
*
RETURN
*
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
    CALL OPF(FN.TELLER.ID,F.TELLER.ID) ;*Manual R22 Conversion - CALL OPF added
*
    FN.TELLER.USER = "F.TELLER.USER"
    F.TELLER.USER  = ""
    CALL OPF(FN.TELLER.USER,F.TELLER.USER) ;*Manual R22 Conversion - CALL OPF added

    FN.REDO.INIT.ID.NV = 'F.REDO.INIT.ID.NV'
    F.REDO.INIT.ID.NV = ''
    CALL OPF(FN.REDO.INIT.ID.NV,F.REDO.INIT.ID.NV)

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
