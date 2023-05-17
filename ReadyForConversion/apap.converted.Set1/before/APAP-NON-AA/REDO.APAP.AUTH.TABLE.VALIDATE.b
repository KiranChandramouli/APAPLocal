*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.AUTH.TABLE.VALIDATE
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: .VALIDATE routine
*------------
*DESCRIPTION:
*------------
* This is the .VALIDATE routine to avaoid the duplication of values entered at the
* field level
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : -na-
*
*---------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 09-NOV-2010   A.SabariKumar     ODR-2010-07-0075       Initial Creation
*---------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.APAP.AUTH.TABLE

  AF = REDO.AUTH.USR.USER.NAME
  CALL DUP
  RETURN
*---------------------------------------------------------------------------
END
