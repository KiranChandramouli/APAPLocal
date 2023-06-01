* @ValidationCode : MjotMTYxNTMyNDU5MzpDcDEyNTI6MTY4NTUzNTg3Mjc4Mjp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:54:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE LATAM.CARD.LIM.DEF.AUTHORISE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : LATAM.CARD.LIM.DEF.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description       :  LATAM.CARD.LIM.DEF.AUTHORISE is an authorisation routine for the template LATAM.CARD.LIM.DEF,
*                     the routine updates the table REDO.INCR.DECR.ATM.POS.AMT with required values
*
*In Parameter      :N/A
*Out Parameter     :N/A
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference                      Description
*   ------         ------               -------------                    -------------
*  02/09/2010      MD.PREETHI          ODR-2010-03-0106 131                 Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.LIM.DEF
    $USING APAP.REDOAPAP

    GOSUB PROCESS.PARA

RETURN

PROCESS.PARA:

*CALL APAP.REDOAPAP.REDO.APAP.INCR.DECR.ATM.POS.AMT.UPD
    APAP.REDOAPAP.redoApapIncrDecrAtmPosAmtUpd();*MANUAL R22 CODE CONVERSION

RETURN
END
