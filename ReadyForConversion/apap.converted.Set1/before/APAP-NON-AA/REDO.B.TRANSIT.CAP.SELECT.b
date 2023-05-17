*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.TRANSIT.CAP.SELECT

*****************************************************************************************
*----------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : KAVITHA
* Program Name  : REDO.B.TRANSIT.CAP.SELECT
*-----------------------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              REFERENCE            DESCRIPTION
* 02-04-2012       ODR-2010-09-0251     INITIAL CREATION
*------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.TRANSIT.CAP.COMMON


  SEL.CMD = ''
  LIST.INTEREST = ''
  BATCH.LIST.IDS = ''
  LOC.ID.VARIABLE = ''

  SEL.CMD = "SELECT ":FN.REDO.TRANUTIL.INTAMT
  CALL EB.READLIST(SEL.CMD,LIST.INTEREST,'',NO.OF.REC,ERR)

  CALL BATCH.BUILD.LIST('',LIST.INTEREST)

  RETURN
*------------------------------------------------------------------------------------------
END
