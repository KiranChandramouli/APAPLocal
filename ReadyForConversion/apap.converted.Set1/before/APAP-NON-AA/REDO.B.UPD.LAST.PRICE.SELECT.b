*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPD.LAST.PRICE.SELECT
*-----------------------------------------------------------------------------------------------
* Company Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed by    : Temenos Application Management
* Program Name    : REDO.B.UPD.LAST.PRICE.SELECT
* Program Type    : BATCH JOB (Multithreaded routine)
*-----------------------------------------------------------------------------------------------
* Description   : This is the Select routine in which we will select all the SECURITY.MASTER and
*                 pass it to the BATCH.BUILD.LIST
*
* In  Parameter : --na--
* Out Parameter : --na--
* ODR Number    : ODR-2010-07-0083
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
* 18.11.2010      Krishna Murthy T.S     SC006         INITIAL CREATION
*
*-------------------------------------------------------------------------------------------------
$INSERT I_EQUATE
$INSERT I_COMMON
$INSERT I_F.SECURITY.MASTER
$INSERT I_F.DATES
$INSERT I_REDO.B.UPD.LAST.PRICE.COMMON

  Y.TODAY = R.DATES(EB.DAT.NEXT.WORKING.DAY)
  SEL.CMD = "SELECT ":FN.SECURITY.MASTER:" WITH MATURITY.DATE LE ":Y.TODAY
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

  CALL BATCH.BUILD.LIST('',SEL.LIST)
  RETURN
END
