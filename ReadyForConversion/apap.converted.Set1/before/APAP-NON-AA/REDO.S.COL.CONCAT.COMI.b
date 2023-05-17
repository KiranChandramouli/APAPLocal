*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.COL.CONCAT.COMI(VALIDATE.PROCESS,CONV.FUNICTON,CONV.PARAM)
* =============================================================================
*
*    First Release :  Paul Pasquel
*    Developed for :  TAM
*    Developed by  :
*    Date          :  2010-11-11
*
*=======================================================================
*  Subroutine Type : Procedure - APAP COLLECTOR ROUTINE RAD MAPPING
*  Attached to     : Called from R.A.D Routines
*  Attached as     :
*  Primary Purpose : RAD.CONVERSION ROUTINE, to concat COMI content
*
*   Description:
*    This is used as RAD.CONVERSION.LIBRARY routine
*    This routine could be use with any RAD.CONDUIT.LINEAR to create a static mapping values
*    For example convert USD by 1, or GBP by 2 or COMMERCIAL by 426
*
*    28. 1 FIELD.ID....... CURRENCY
*    29. 1 FIELD.TYPE..... REPORT
*    30. 1 IN.POSITION.... 1,1
*    31. 1 OUT.POSITION... 1,1
*    32. 1. 1 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*    33. 1. 1 CONV.PARAM.. DOP,1
*    32. 1. 2 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*    33. 1. 2 CONV.PARAM.. USD,2
*    32. 1. 3 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*    33. 1. 3 CONV.PARAM.. EUR,3
*    32. 1. 4 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*    33. 1. 4 CONV.PARAM.. CAD,4
*
* After you call to RAD.CONDUIT.LINEAR.TRANSLATION you will get CURRENCY]DOP,1]USD,2]EUR,3]CAD,4]GBP,5]CHF,6]JPY,7
*
* Incoming:
* ---------
* VALIDATE.PROCESS   - VALIDATE or PROCESS
* CONV.FUNCTION      - CONVERSION Function
* CONV.PARAM         - CONVERSION Parameter
*
* Outgoing:
* ---------
* COMI               - If Validate/Process is PROCESS
*
* Error Variables:
* ----------------
* E                  - Any Error Message
*
*
$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_F.VERSION
*
*************************************************************************
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
* ======
PROCESS:
* ======
*
*
  IF WE.ARE.VALIDATING THEN
    IF CONV.PARAM EQ '' THEN
      E = '& - INPUT MISSING' :FM: 'CONV.PARAM'
    END
  END ELSE
* The firs Position of the COMI is the current FIELD.ID
    IF COMI EQ "" THEN
      COMI = CONV.PARAM
    END ELSE
      COMI = COMI : VM :CONV.PARAM
    END
  END

  RETURN
*
*
* ---------
INITIALISE:
* ---------
*
  PROCESS.GOAHEAD = 1
  WE.ARE.VALIDATING = VALIDATE.PROCESS EQ 'VALIDATE'
*
*
  RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*
  RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
*    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
**
*    LOOP
*    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
*        BEGIN CASE
*        CASE LOOP.CNT EQ 1
*
*             IF condicion-de-error THEN
*                PROCESS.GOAHEAD = 0
*                E = "EB-mensaje-de-error-para-la-tabla-EB.ERROR"
*             END
**
*        END CASE
*        LOOP.CNT +=1
*    REPEAT
**
  RETURN
*
END
