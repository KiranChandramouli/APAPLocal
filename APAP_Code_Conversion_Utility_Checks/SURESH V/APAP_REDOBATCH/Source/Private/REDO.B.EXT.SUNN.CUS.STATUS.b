* @ValidationCode : MjotNDUyMTc3MDcwOkNwMTI1MjoxNjg0ODU0Mzg2NTU2OklUU1M6LTE6LTE6MTAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.EXT.SUNN.CUS.STATUS(Y.ID)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.EXT.SUNN.COMMON
    $INSERT I_F.REDO.STORE.SUNN.CUS.ST
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    Y.CUS = FIELD(Y.ID,',',1)
    Y.STAUS = FIELD(Y.ID,',',2)


    R.VAL<SUN.CUS.STATUS> = Y.STAUS

    CALL F.WRITE(FN.REDO.STORE.SUNN.CUS.ST,Y.CUS,R.VAL)

    CALL OCOMO('PROCESSED CUSTOMER - ':Y.CUS)

RETURN

END
