* @ValidationCode : MjoxMzMzNzkyOTpDcDEyNTI6MTY4MDY3MTc1Nzg2NzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:45:57
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHK.VIRGIN.STOCK.REGISTER
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CHK.VIRGIN.STOCK.REGISTER
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to Automatically populate ID
*Linked With  : STOCK.ENTRY,REDO.VIRGIN
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 16 MAR 2011    SWAMINATHAN       ODR-2010-03-0400        Initial Creation
** 05-04-2023 R22 Auto Conversion no changes
** 05-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.USER
    $INSERT I_F.REDO.STOCK.ENTRY
    $INSERT I_F.REDO.CARD.SERIES.PARAM

    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
    CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)
    R.REDO.CARD.SERIES.PARAM = ''

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------------------------------
********
PROCESS:
*********
    FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)
    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    VIRGIN.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.VIRGIN.DEPT.CODE>
    R.NEW(STK.TO.REGISTER) = 'CARD.':FINAL.COMP:'-':VIRGIN.DEPT.CODE
    R.NEW(STK.IN.OUT.DATE) = TODAY
RETURN
*-----------------------------------------------------------------------------------------------------------
END
