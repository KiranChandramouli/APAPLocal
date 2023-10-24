* @ValidationCode : Mjo1NjMyOTY3NzE6Q3AxMjUyOjE2ODEzNzExMDM3NjM6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:01:43
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.R.COL.PROCESS.TRACE(P.TYPE_PROC, P.STATUS, P.REC_NO, P.TABLE, P.DETAILS, P.ERR_MSG)
********************************************************************
* Company   Name    : APAP
* Developed By      : Temenos Application Management mgudino@temenos.com
*--------------------------------------------------------------------------------------------
* Description:       This program Make the register of TRACE Summary about extract and delivery process
* Linked With:       REDO,COL.EXTRACT, REDO.COL.DELIVERY
* In Parameter:      P.TYPE_PROC, P.STATUS, P.REC_NO, P.TABLE, P.DETAILS, P.ERR_MSG
* Out Parameter:
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 23/07/2009 - ODR-2009- XX-XXXX
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             VM TO @VM, ++ TO +=
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------


    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DE.ADDRESS
    $INSERT I_F.REDO.COL.TRACE


    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
 
*-----------------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------------

    Y.TIME.VAR = TIMEDATE()

    FN.REDO.COL.TRACE = 'F.REDO.COL.TRACE'
    F.REDO.COL.TRACE = ''
    CALL OPF(FN.REDO.COL.TRACE,F.REDO.COL.TRACE)

    FN.REDO.COL.TRACE.SUM = 'F.REDO.COL.TRACE.SUM'
    F.REDO.COL.TRACE.SUM = ''
    CALL OPF(FN.REDO.COL.TRACE.SUM,F.REDO.COL.TRACE.SUM)

RETURN

*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------

    R.REDO.COL.TRACE = ''

    R.REDO.COL.TRACE<REDO.COL.TRC.TYPE.PROCESS> = P.TYPE_PROC
    R.REDO.COL.TRACE<REDO.COL.TRC.STATUS> = P.STATUS
    R.REDO.COL.TRACE<REDO.COL.TRC.REC.NO> = P.REC_NO
    R.REDO.COL.TRACE<REDO.COL.TRC.TABLE> = P.TABLE
    R.REDO.COL.TRACE<REDO.COL.TRC.DETAILS> = P.DETAILS
    R.REDO.COL.TRACE<REDO.COL.TRC.PROCESS.DATE> = TODAY
    R.REDO.COL.TRACE<REDO.COL.TRC.DATE.TIME> = Y.TIME.VAR
    R.REDO.COL.TRACE<REDO.COL.TRC.MESSAGE> = P.ERR_MSG

    GOSUB WRITE.RECORD

*    GOSUB WRITE.RECORD.SUM

RETURN
*-----------------------------------------------------------------------------------
WRITE.RECORD:
*-----------------------------------------------------------------------------------

    Y.REDO.COL.TRACE.ID = ''
    CALL ALLOCATE.UNIQUE.TIME(Y.REDO.COL.TRACE.ID)
    Y.REDO.COL.TRACE.ID = TODAY:".":Y.REDO.COL.TRACE.ID


*  WRITE  R.REDO.COL.TRACE TO F.REDO.COL.TRACE,Y.REDO.COL.TRACE.ID ;*Tus Start
    CALL F.WRITE(FN.REDO.COL.TRACE,Y.REDO.COL.TRACE.ID,R.REDO.COL.TRACE);*Tus End
    IF NOT(PGM.VERSION) AND NOT(RUNNING.UNDER.BATCH) THEN
        CALL JOURNAL.UDPATE('')
    END

RETURN

*------------------------------------
WRITE.RECORD.SUM:
*----------------------------------------

    Y.REDO.COL.TRACE.SUM.L.ID = TODAY:".":P.TYPE_PROC:".":P.TABLE:".":P.DETAILS:".":P.STATUS

    IF P.STATUS MATCHES "10":@VM:"20" THEN
        Y.TOTAL = 0

        R.REDO.COL.TRACE.SUM = ""

*    READU R.REDO.COL.TRACE.SUM FROM F.REDO.COL.TRACE.SUM, Y.REDO.COL.TRACE.SUM.L.ID THEN ;*Tus Start
        RETRY.VAR = ""
        CALL F.READU(FN.REDO.COL.TRACE.SUM,Y.REDO.COL.TRACE.SUM.L.ID,R.REDO.COL.TRACE.SUM,F.REDO.COL.TRACE.SUM,R.REDO.COL.TRACE.SUM.ERR,RETRY.VAR)
        IF R.REDO.COL.TRACE.SUM THEN  ;* Tus End
            Y.TOTAL = R.REDO.COL.TRACE.SUM<1>
        END
        Y.TOTAL += 1 ;*AUTO R22 CODE CONVERSION
        R.REDO.COL.TRACE.SUM<1> = Y.TOTAL
        R.REDO.COL.TRACE.SUM<2> = P.STATUS
        R.REDO.COL.TRACE.SUM<3> = Y.REDO.COL.TRACE.ID
        R.REDO.COL.TRACE.SUM<4> = P.ERR_MSG


*    WRITE  R.REDO.COL.TRACE.SUM TO F.REDO.COL.TRACE.SUM,Y.REDO.COL.TRACE.SUM.L.ID ;*Tus Start
        CALL F.WRITE(FN.REDO.COL.TRACE.SUM,Y.REDO.COL.TRACE.SUM.L.ID,R.REDO.COL.TRACE.SUM);*Tus End
        IF NOT(PGM.VERSION) AND NOT(RUNNING.UNDER.BATCH) THEN
            CALL JOURNAL.UDPATE('')
        END
*    RELEASE F.REDO.COL.TRACE.SUM, Y.REDO.COL.TRACE.SUM.L.ID ;*Tus Start
        CALL F.RELEASE(FN.REDO.COL.TRACE.SUM,Y.REDO.COL.TRACE.SUM.L.ID,F.REDO.COL.TRACE.SUM);*Tus End

    END


RETURN
END
