SUBROUTINE REDO.GIT.CUSGRP.FORMAT(GIT.MAP.DATA,ERR.MSG)
*-----------------------------------------------------------------------------
*DESCRIPTION
*-------------------------------------------------------------------------------------------------------
* This routine is atached to GIT.MAPPING.IN to format the L.CU.G.LEALTAD(Multi value field)
*-------------------------------------------------------------------------------------------------------
*IN/OUT PARAMETERS:
*--------------------
* IN:
*-----
* GIT.MAP.DATA
*OUT:
*-----
* GIT.MAP.DATA
* ERR.MSG
*-----------------------------------------------------------------------------------------------
* MODIFICATION HISTORY:
*---------------------
* Date            Who                Reference               Description
* 07-OCT-2009   SUDHARSANAN S        TAM-ODR-2010-09-0012     INITIAL VERSION
*-----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.GIT.MAPPING.IN
    $INSERT I_GIT.COMMON

    GOSUB PROCESS
RETURN
*-------------------------------------------------------------------------------------------------------
PROCESS:
*---------
    CHANGE '^' TO CHARX(165) IN GIT.MAP.DATA
RETURN
*-------------------------------------------------------------------------------------------------------
END
