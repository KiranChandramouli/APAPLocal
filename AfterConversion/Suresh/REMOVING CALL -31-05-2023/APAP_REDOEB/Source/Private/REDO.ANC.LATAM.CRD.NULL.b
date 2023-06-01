* @ValidationCode : MjoxMjc4NjYzMTU1OkNwMTI1MjoxNjgxOTc5NTk3NjMxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE REDO.ANC.LATAM.CRD.NULL

*--------------------------------------------------------------------------------------------------------
*Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By : Temenos Application Management
*Program Name : LATAM.CARD.ORDER.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description : This is a process routine to update renewal status on changing renewal status of damaged card
*Linked With : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date Who Reference Description
* ------ ------ ------------- -------------
* 1 Sep 2011 Balagurunathan ODR-2010-03-0400 (PACS00093181) Initial Creation
*
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.ORDER

    R.NEW(CARD.IS.RENEW.STATUS)=''


RETURN


END
