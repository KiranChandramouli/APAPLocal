* @ValidationCode : Mjo3NDA3MTAxOkNwMTI1MjoxNjg0ODU0MzgxNDE2OklUU1M6LTE6LTE6Mzk4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 398
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.BUILD.SEL.FC(ENQ.DATA)
*-----------------------------------------------------------------------------
* Developed by : TAM
* Issue Reference : PACS00237933
* Description: This is build routine used to form the selection criteria
*-----------------------------------------------------------------------------
*Modification History
*
* 19-Mar-2013  Sivakumar.K  PACS00255148
* Date                  who                   Reference              
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT

    Y.VAL = R.NEW(REDO.PDIS.ID.ARRANGEMENT)

    IF ENQ.DATA<1,1> EQ 'E.REDO.CHARGES.PDIS' THEN

*PACS00255148_S
        FN.ARRANGEMENT = 'F.AA.ARRANGEMENT'
        F.ARRANGEMENT = ''
        CALL OPF(FN.ARRANGEMENT,F.ARRANGEMENT)
        CALL F.READ(FN.ARRANGEMENT,Y.VAL,R.ARRANGEMENT,F.ARRANGEMENT,ARR.ERR)
        IF R.ARRANGEMENT THEN
            ENQ.DATA<4,1> = Y.VAL
        END ELSE
            FN.ACCOUNT = 'F.ACCOUNT'
            F.ACCOUNT = ''
            CALL OPF(FN.ACCOUNT,F.ACCOUNT)
            CALL F.READ(FN.ACCOUNT,Y.VAL,R.ACCOUNT,F.ACCOUNT,AC.ERR)
            IF R.ACCOUNT THEN
                ENQ.DATA<4,1> = R.ACCOUNT<AC.ARRANGEMENT.ID>
            END
        END
*PACS00255148_E

        ENQ.DATA<2,1>= 'Y.ARR.ID'
        ENQ.DATA<3,1>= 'EQ'
    END
    IF ENQ.DATA<1,1> EQ 'E.REDO.CHARGES.DIS' THEN
        ENQ.DATA<2,1>= 'R.DATA'
        ENQ.DATA<3,1>= 'EQ'
        ENQ.DATA<4,1> = Y.VAL
    END

RETURN

END
