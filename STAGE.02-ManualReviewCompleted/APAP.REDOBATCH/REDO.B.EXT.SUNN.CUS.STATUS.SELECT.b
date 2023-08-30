* @ValidationCode : MjotNTU2OTIzMjc3OkNwMTI1MjoxNjgxMTkxOTA5NDE1OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:15:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.EXT.SUNN.CUS.STATUS.SELECT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 11-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.EXT.SUNN.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM

    CALL F.READ(FN.REDO.INTERFACE.PARAM,'SUN001',R.INT.PARAM,F.REDO.INTERFACE.PARAM,PAR.ERR)
    F.FILE.PATH = R.INT.PARAM<REDO.INT.PARAM.FI.AUTO.PATH>

    OPEN F.FILE.PATH TO Y.PTR ELSE

        RETURN
    END

    Y.FILE.NAME = 'customerestatus.txt'
    READ Y.MSG FROM Y.PTR,Y.FILE.NAME THEN

        CALL BATCH.BUILD.LIST('',Y.MSG)
    END

RETURN
END
