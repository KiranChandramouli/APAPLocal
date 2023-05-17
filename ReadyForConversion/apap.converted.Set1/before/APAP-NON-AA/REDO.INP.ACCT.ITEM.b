*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INP.ACCT.ITEM
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.TELLER.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.TEL.GROUP
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*27-05-2011     Sudharsanan S       PACS00062653    Initial Creation
* -----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COMPANY
$INSERT I_F.REDO.H.MAIN.COMPANY
$INSERT I_F.REDO.ITEM.STOCK
$INSERT I_F.REDO.H.REASSIGNMENT
$INSERT I_GTS.COMMON

  GOSUB INIT
  GOSUB PROCESS1
  RETURN
*---
INIT:
*---

  FN.REDO.ITEM.STOCK = 'F.REDO.ITEM.STOCK'
  F.REDO.ITEM.STOCK = ''
  CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)
  FN.REDO.H.MAIN.COMPANY ='F.REDO.H.MAIN.COMPANY'
  F.REDO.H.MAIN.COMPANY = ''
  CALL OPF(FN.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY)

  RETURN

*---------------------------------------------------------------------------------------
PROCESS1:
*---------------------------------------------------------------------------------------
  Y.GROUP = R.NEW(RE.ASS.DEPT)
  CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.GROUP,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)
  Y.CODE = R.NEW(RE.ASS.CODE)
  LOCATE Y.CODE IN R.REDO.H.MAIN.COMPANY<REDO.COM.CODE,1> SETTING POS.1.1 THEN
    R.NEW(RE.ASS.DEPT.DES) = R.REDO.H.MAIN.COMPANY<REDO.COM.DESCRIPTION,POS.1.1>

  END
  RETURN

END
