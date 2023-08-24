* @ValidationCode : MjotMTc3NDEzOTU1NDpDcDEyNTI6MTY4MDYxOTc1Nzg5MjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 20:19:17
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
SUBROUTINE REDO.CHANGE.ARR.TO.ACC.BUILD(ENQ.DATA)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used as BUILD routine, to accept arrangement id and account no in selection criteria.
*-------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 26-09-2011        S.MARIMUTHU     PACS00128531         Initial Creation
* 04.04.2023    Conversion Tool      R22                 Auto Conversion     - No changes
* 04.04.2023    Shanmugapriya M      R22                 Manual Conversion   - No changes
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT


MAIN:

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING POS THEN
        Y.ID = ENQ.DATA<4,1>
        IF Y.ID[1,2] NE 'AA' THEN
            CALL F.READ(FN.ACCOUNT,Y.ID,R.ACC,F.ACCOUNT,AA.ERR)
            Y.AC.ID = R.ACC<AC.ARRANGEMENT.ID>
            ENQ.DATA<4,POS> = Y.AC.ID
        END
    END

    GOSUB PGM.END

RETURN

PGM.END:

END
