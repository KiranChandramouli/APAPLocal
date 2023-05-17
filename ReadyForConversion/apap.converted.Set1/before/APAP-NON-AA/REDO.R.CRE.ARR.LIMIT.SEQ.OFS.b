*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.R.CRE.ARR.LIMIT.SEQ.OFS(Y.REQUEST, Y.RESPONSE)
*----------------------------------------------------------------------------------------------------
* DESCRIPTION :
*              This routines allows to call REDO.R.CRE.ARR.LIMIT.SEQ.UPD routine with P.ACTION = U, through OFS
*-----------------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN Parameter    :
*                     Y.REQUEST        is list of values separated by |
*                           <1>        CUSTOMER.ID
*                           <2>        LIMIT.REF
*                           <3>        LAST.ID
*                           <4>        LAST.COLL.ID
* OUT Parameter   :
*                     Y.RESPONSE       is equals "//1" then everything OK
*                                      is equals "//-1" this has to have the error message
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : hpasquel@temenos.com
* PROGRAM NAME : REDO.CREATE.ARRANGEMENT.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference         Description
* 05-Jan-2011    Paul Pasquel      ODR-2009-11-0199    Initial creation
*------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE

  GOSUB PROCESS
  RETURN
*------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------

  Y.REQUEST = CHANGE(Y.REQUEST,"|",FM)
  P.CUSTOMER.ID = Y.REQUEST<1>
  P.LIMIT.REF = Y.REQUEST<2>
  P.ACTION = "U"
  P.LAST.ID = Y.REQUEST<3>
  P.LAST.COLL.ID = Y.REQUEST<4>
  E = ""
  CALL REDO.R.CRE.ARR.LIMIT.SEQ.UPD(P.CUSTOMER.ID, P.LIMIT.REF, P.ACTION, P.LAST.ID, P.LAST.COLL.ID)
  Y.RESPONSE = ""

  IF E EQ "" THEN
    CALL JOURNAL.UPDATE("REDO.R.CRE.ARR.LIMIT.SEQ.OFS")
    Y.RESPONSE = "//1"
  END ELSE
    Y.RESPONSE = "//-1," : E
  END
  RETURN
*------------------------------------------------------------------------------------------------------
END
