$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CNV.DIFF.DAYS
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* conversion routine to return the number of days between activation and issue date time

*------------------------------------------------------------------------------------------------------
*APPLICATION
* ENQUIRY REDO.DEBIT.CARD.ACTIVE.ENQ
*-------------------------------------------------------------------------------------------------------

*
* Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.CNV.DIFF.DAYS
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO         REFERENCE         DESCRIPTION
*17.03.2011      Janani     ODR-2010-03-0153  INITIAL CREATION
*
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*----------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    GOSUB INIT
    GOSUB PROCESS
RETURN

*------------------------------------------------------------
INIT:
*------------------------------------------------------------
    ISSUE.DATE = FIELD(O.DATA," ",1)
    ISSUE.TIME = FIELD(O.DATA," ",2)
    ACTIVE.DATE = FIELD(O.DATA," ",3)
    ACTIVE.TIME = FIELD(O.DATA," ",4)
RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

    IF ISSUE.DATE AND ISSUE.TIME AND ACTIVE.DATE AND ACTIVE.TIME THEN
        DIFF.DAYS = "C"
        CALL CDD("",ISSUE.DATE,ACTIVE.DATE,DIFF.DAYS)
        ACTIVE.MIN = ACTIVE.TIME[1,2] * 60 + ACTIVE.TIME[4,2]
        ISSUE.MIN = ISSUE.TIME[1,2] * 60 + ISSUE.TIME[4,2]
        DIFF.MIN = ISSUE.MIN - ACTIVE.MIN

        IF DIFF.MIN LT 0 THEN
            O.DATA = DIFF.DAYS : " DIAS "
            Y.HRS =  FMT(INT(ABS(DIFF.MIN) / 60),"R%2")
            O.DATA := Y.HRS : " HR "
            Y.SEC = FMT(MOD(ABS(DIFF.MIN),60),"R%2")
            O.DATA := Y.SEC : " MIN"
        END ELSE
            O.DATA = DIFF.DAYS - 1 :" DAY "
            DIFF.MIN=(ACTIVE.MIN+1440)-ISSUE.MIN
            Y.HRS =  FMT(INT(ABS(DIFF.MIN) / 60),"R%2")
            O.DATA := Y.HRS : " HR "
            Y.SEC = FMT(MOD(ABS(DIFF.MIN),60),"R%2")
            O.DATA := Y.SEC : " MIN"
        END
    END ELSE
        O.DATA = ''
    END

RETURN
*------------------------------------------------------------
END
