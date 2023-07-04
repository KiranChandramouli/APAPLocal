* @ValidationCode : MjotMjUzMzQ3MTE4OkNwMTI1MjoxNjgwNjc2MzMyMzE1OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:02:12
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.GET.ALT.ACCT
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* It is Conversion Routine can be used when a multivalue field
* used to display in enquiry
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                 Reference
* 24-MAY-13      RIYAS              INITIALVERSION
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*---------------------------------------------------------------------------
*

    CALL F.READ(FN.ACCOUNT,O.DATA,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    Y.ALT.ACCT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
    CHANGE @VM TO @FM IN Y.ALT.ACCT.TYPE
    CHANGE @VM TO @FM IN Y.ALT.ACCT.ID
    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE SETTING ALT.POS THEN
        O.DATA = Y.ALT.ACCT.ID<ALT.POS>
    END ELSE
        O.DATA = ''
    END
RETURN
END
