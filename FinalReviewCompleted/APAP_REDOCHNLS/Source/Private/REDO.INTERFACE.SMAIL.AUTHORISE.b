* @ValidationCode : MjoxMTYzMzMxOTA4OkNwMTI1MjoxNjg0ODU0MDU0NDYwOklUU1M6LTE6LTE6LTIyOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:30:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -22
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
SUBROUTINE REDO.INTERFACE.SMAIL.AUTHORISE
*-----------------------------------------------------------------------------
*** Simple AUTHORISE template
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package infra.eb
*!

*** <region name= PROGRAM DESCRIPTION>
*** <desc>Program description</desc>
*-----------------------------------------------------------------------------
* Program Description
*** </region>

*** <region name= MODIFICATION HISTORY>
*** <desc>Modification history</desc>
*-----------------------------------------------------------------------------
* Modification History:
** DATE              WHO                REFERENCE                 DESCRIPTION
* 11-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 11-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
*-----------------------------------------------------------------------------
*** </region>

*** <region name= INSERTS>
*** <desc>Inserts</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING APAP.TAM
*** </region>
*-----------------------------------------------------------------------------

*** <region name= MAIN PROCESS LOGIC>
*** <desc>Main process logic</desc>
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
*** <desc>Process</desc>
PROCESS:
*APAP.TAM.REDO.R.INTERFACE.SMAIL.FILE.PROPERTIES ;*Manual R22 conversion
    APAP.TAM.redoRInterfaceSmailFileProperties()  ;*Manual R22 conversion

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
*** <desc>Initialise</desc>
INITIALISE:

RETURN
*** </region>
END
