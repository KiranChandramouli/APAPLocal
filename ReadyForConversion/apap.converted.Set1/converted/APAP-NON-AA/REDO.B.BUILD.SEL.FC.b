SUBROUTINE REDO.B.BUILD.SEL.FC(ENQ.DATA)
*-----------------------------------------------------------------------------
* Developed by : TAM
* Issue Reference : PACS00237933
* Description: This is build routine used to form the selection criteria
*-----------------------------------------------------------------------------
*Modification History
*
* 19-Mar-2013  Sivakumar.K  PACS00255148
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
