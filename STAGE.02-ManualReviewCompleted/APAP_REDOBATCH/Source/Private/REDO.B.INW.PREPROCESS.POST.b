* @ValidationCode : MjoyMDc4OTU1MDk2OkNwMTI1MjoxNjg0ODU0Mzg4MTA2OklUU1M6LTE6LTE6OTQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 94
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.INW.PREPROCESS.POST
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : ganesh r
* PROGRAM NAME : REDO.B.INW.PREPROCESS.POST
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 21.09.2010  ganesh r           ODR-2010-09-0148   INITIAL CREATION
* Date                  who                   Reference              
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.INW.PREPROCESS.COMMON
*------------------------------------------------------------------------------------------

    GOSUB PROCESS
RETURN

PROCESS:
*------------------------------------------------------------------------------------------

    IF Y.POST.ID THEN
        DAEMON.CMD = "DELETE ":VAR.FILE.PATH:" *"
        EXECUTE DAEMON.CMD
    END
RETURN

END
