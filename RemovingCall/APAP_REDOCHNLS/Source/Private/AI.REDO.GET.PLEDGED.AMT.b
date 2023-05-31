* @ValidationCode : MjoxNTE0Nzk5MDQyOkNwMTI1MjoxNjg0ODU0MDUwMjM2OklUU1M6LTE6LTE6MTc5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:30:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 179
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS

SUBROUTINE AI.REDO.GET.PLEDGED.AMT
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Martin Macias
* Program Name :
*-----------------------------------------------------------------------------
* Description    :  This routine will get pledged amount for a Customer Acct if any
* Linked with    :
* In Parameter   :
* Out Parameter  :
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       I to I.VAR
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    $INSERT I_F.APAP.H.GARNISH.DETAILS

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*----------*
INITIALISE:
*----------*

    FN.APAP.H.GARNISH.DETAILS = "F.APAP.H.GARNISH.DETAILS"
    F.APAP.H.GARNISH.DETAILS = ''

    ACCT.NO = O.DATA
    PLEDGED.AMT = 0

RETURN

*----------*
OPEN.FILES:
*----------*

    CALL OPF(FN.APAP.H.GARNISH.DETAILS,F.APAP.H.GARNISH.DETAILS)

RETURN

*--------*
PROCESS:
*--------*

    SEL.CMD = "SELECT ":FN.APAP.H.GARNISH.DETAILS:" WITH ACCOUNT.NO EQ ":ACCT.NO
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.ERR)

    FOR I.VAR = 1 TO NO.OF.REC
        CALL F.READ(FN.APAP.H.GARNISH.DETAILS,SEL.LIST<I.VAR>,R.PLEDGED,F.APAP.H.GARNISH.DETAILS,PLEDGED.ERR)
        ACCT.LIST = R.PLEDGED<APAP.GAR.ACCOUNT.NO>
        LOCATE ACCT.NO IN ACCT.LIST<1,1> SETTING Y.ACCT.POS THEN
            PLEDGED.AMT += R.PLEDGED<APAP.GAR.GARNISH.AMT,Y.ACCT.POS>
        END
    NEXT I.VAR

    O.DATA = PLEDGED.AMT

RETURN

END
