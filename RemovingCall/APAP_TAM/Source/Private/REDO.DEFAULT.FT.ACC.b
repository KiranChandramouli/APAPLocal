* @ValidationCode : Mjo4MjI5Mzg0MzU6Q3AxMjUyOjE2ODQ0OTEwMzIwMDA6SVRTUzotMTotMTozMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 300
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.DEFAULT.FT.ACC
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is used to default the FT Credit Account number for the disbursement
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date        who                     Reference           Description
* 08/03/2013  Vignesh Kumaar M R      PACS00251027        To update the credit account number
* 29/06/2017  Edwin Charles D         R15 Upgrade         Version is changed from FT to lOCAL Template
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_F.REDO.BRANCH.INT.ACCT.PARAM

    FN.REDO.BRANCH.INT.ACCT.PARAM = 'F.REDO.BRANCH.INT.ACCT.PARAM'
    F.REDO.BRANCH.INT.ACCT.PARAM = ''
    R.REDO.BRANCH.INT.ACCT.PARAM = ''
    CALL OPF(FN.REDO.BRANCH.INT.ACCT.PARAM,F.REDO.BRANCH.INT.ACCT.PARAM)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    REC.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.BRANCH.INT.ACCT.PARAM,REC.ID,R.REDO.BRANCH.INT.ACCT.PARAM,E.REDO.BRANCH.INT.ACCT.PARAM)

    Y.VERSION.NAME = APPLICATION:PGM.VERSION
    GET.VERSION.ARR = R.REDO.BRANCH.INT.ACCT.PARAM<BR.INT.ACCT.VERSION.NAME>

    LOCATE Y.VERSION.NAME IN GET.VERSION.ARR<1,1> SETTING ACC.POS THEN
        Y.CRD.ID = R.REDO.BRANCH.INT.ACCT.PARAM<BR.INT.ACCT.INT.ACCOUNT,ACC.POS>
        R.NEW(FT.TN.CREDIT.ACCT.NO) = Y.CRD.ID
        CALL F.READ(FN.ACCOUNT,Y.CRD.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        R.NEW(FT.TN.CREDIT.CURRENCY) = R.ACCOUNT<AC.CURRENCY>
    END

RETURN

END
