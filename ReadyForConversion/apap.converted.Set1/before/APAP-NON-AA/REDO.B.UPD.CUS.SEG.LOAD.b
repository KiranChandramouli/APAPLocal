*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPD.CUS.SEG.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This load routine initialises and opens necessary files
*  and gets the position of the local reference fields
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar   ODR-2009-12-0281      Initial Creation
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_REDO.B.UPD.CUS.SEG.COMMON

  GOSUB INIT
  GOSUB GET.LR.FLD.POS
  GOSUB OPEN.FILE

  RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

  APP.NAME = 'CUSTOMER'
  OFSFUNCT = 'I'
  PROCESS  = 'PROCESS'
  OFSVERSION = 'CUSTOMER,REDO.SEGMENTACION'
  GTSMODE = ''
  NO.OF.AUTH = '0'
  OFS.SOURCE.ID = 'REDO.CUS.SEG.UPD'

  RETURN

*--------------
GET.LR.FLD.POS:
*--------------
*-------------------------------------------------------------
* This section gets the position of the local reference fields
*-------------------------------------------------------------

  LOC.REF.POS = ''
  CUS.SEG.POS = ''
  OVR.SEG.POS = ''

  LOC.REF.FIELDS = 'L.CU.SEGMENTO':VM:'L.CU.OVR.SEGM'
  CALL MULTI.GET.LOC.REF('CUSTOMER',LOC.REF.FIELDS,LOC.REF.POS)
  CUS.SEG.POS = LOC.REF.POS<1,1>
  OVR.SEG.POS = LOC.REF.POS<1,2>

  RETURN

*---------
OPEN.FILE:
*---------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  RETURN

END
