* @ValidationCode : MjoxNTEwNTA2MjE4OkNwMTI1MjoxNzAyOTYzODcwMDE0OjMzM3N1Oi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:01:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.SCHEDULE.PROJECTOR(Y.AA.ID)
*----------------------------------------------------------
*------------------------------------------------------------
*Description: This service routine is to update the concat table about the schedule projector
* for each arrangement. This needs to be runned only once after that activity api routine will
* update the concat table during schedule changes.
*--------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*18/12/2023        Suresh           R22 Manual Conversion  -  CALL routine modified
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.SCHEDULE.PROJECTOR.COMMON
    
    $USING AA.PaymentSchedule ;*R22 Manual Conversion

    CALL OCOMO("started processing the arrangement:[ ":Y.AA.ID:" ]")
    NO.RESET       = ''
    DATE.RANGE     = ''
    SIMULATION.REF = ''
*    CALL AA.SCHEDULE.PROJECTOR(Y.AA.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS,DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
    AA.PaymentSchedule.ScheduleProjector(Y.AA.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS,DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS) ;*R22 Manual Conversion
    R.REDO.AA.SCHEDULE    = ''
    R.REDO.AA.SCHEDULE<1> = LOWER(TOT.PAYMENT)
    R.REDO.AA.SCHEDULE<2> = LOWER(DUE.DATES)
    R.REDO.AA.SCHEDULE<3> = LOWER(DUE.TYPES)
    R.REDO.AA.SCHEDULE<4> = LOWER(DUE.METHODS)
    R.REDO.AA.SCHEDULE<5> = LOWER(DUE.TYPE.AMTS)
    R.REDO.AA.SCHEDULE<6> = LOWER(DUE.PROPS)
    R.REDO.AA.SCHEDULE<7> = LOWER(DUE.PROP.AMTS)
    R.REDO.AA.SCHEDULE<8> = LOWER(DUE.OUTS)
    R.REDO.AA.SCHEDULE<9> = 'BATCH'
    CALL F.WRITE(FN.REDO.AA.SCHEDULE,Y.AA.ID,R.REDO.AA.SCHEDULE)
    CALL OCOMO("Completed processing the arrangement:[ ":Y.AA.ID:" ]")

RETURN
END
