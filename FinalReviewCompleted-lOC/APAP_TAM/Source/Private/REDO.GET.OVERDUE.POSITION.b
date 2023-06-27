$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.OVERDUE.POSITION(ARR.ID, OD.STATUS, OD.POS, TOTAL.OD)

*
* This is a call routine, which returns the Overdue position for the Arrangement.
*
* This routine reads the Overdue Arrangement Condition and returns the Overdue postion
*
* Input Arguments:
*
*         ARR.ID    - Arrangement ID (Mandatory)
*         OD.STATUS - Overdue Status for which the Postion is Required. (Mandatory)
*
* Output Arguments:
*
*         OD.POS    - Postion of Overdue Status
*         TOTAL.OD  - Total Overdue Statuses
*

*
*----------------------------------------------------------------------------------------------------------------------------
*
* Modification History
*
*----------------------------------------------------------------------------------------------------------------------------
*   Date               |           Who                    |           Reference                    |          Description
*----------------------------------------------------------------------------------------------------------------------------
*
*  Apr-12                      Ravikiran AV                      ODR-2012-01-0106 (CR-44)                    Zero Principal
*
*** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------------------------------------------------------------
*
* All file INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.AA.OVERDUE

*----------------------------------------------------------------------------------------------------------------------------
* Main Logic
*
MAIN.LOGIC:

    GOSUB GET.OVERDUE.POSTION

RETURN

*----------------------------------------------------------------------------------------------------------------------------
* Returns the Overdue postion for the arrangement
*

GET.OVERDUE.POSTION:

    GOSUB GET.OVERDUE.RECORD

    GOSUB GET.OD.POSTION

RETURN
*----------------------------------------------------------------------------------------------------------------------------
*
*
GET.OVERDUE.RECORD:

    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID, 'OVERDUE', '', '', RET.VAL, RET.COND, RET.ERR)

    RET.COND = RAISE(RET.COND)

    OD.COND.STATUS = RET.COND<AA.OD.OVERDUE.STATUS>

*  TOTAL.OD = DCOUNT(OD.COND.STATUS,VM)  ;* Total Overdue Status
    TOTAL.OD = DCOUNT(OD.COND.STATUS,@SM)  ;* Total Overdue Status

RETURN
*----------------------------------------------------------------------------------------------------------------------------
*
*
GET.OD.POSTION:

    IF (OD.STATUS EQ 'CUR' OR OD.STATUS EQ 'DUE') THEN

        OD.POS = 0      ;*If Arrangement is not in Ageing then return the postion as 0

    END ELSE

        LOCATE OD.STATUS IN RET.COND<AA.OD.OVERDUE.STATUS,1,1> SETTING POS THEN

            OD.POS = POS

        END
    END

RETURN
*----------------------------------------------------------------------------------------------------------------------------
*
*
END
