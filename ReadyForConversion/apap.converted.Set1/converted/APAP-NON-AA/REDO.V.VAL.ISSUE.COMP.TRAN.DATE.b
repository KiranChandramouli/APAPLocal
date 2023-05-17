SUBROUTINE REDO.V.VAL.ISSUE.COMP.TRAN.DATE
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : A Validation routine is written to check whether the TRANSACTION.DATE is greater
*than 4 years from today, an error message is displayed as no valid claim date
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.VAL.ISSUE.COMP.TRAN.DATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 27.07.2010      SUDHARSANAN S     ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ISSUE.COMPLAINTS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------
    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS  = ''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)

    NO.OF.DAYS = 'C'
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------
    DATE.TODAY = TODAY
    TXN.DATE   = COMI
    IF DATE.TODAY NE '' AND TXN.DATE NE '' THEN
        CALL CDD('',DATE.TODAY,TXN.DATE,NO.OF.DAYS)
    END
    IF NO.OF.DAYS GT 1461 THEN
        AF= ISS.COMP.TRANSACTION.DATE
        ETEXT='EB-NO.VAL.CLAIM.DATE'
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------------------------------------------------------
END
