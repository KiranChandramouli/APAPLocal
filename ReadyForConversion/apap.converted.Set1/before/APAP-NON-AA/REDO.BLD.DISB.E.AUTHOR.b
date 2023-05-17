    SUBROUTINE REDO.BLD.DISB.E.AUTHOR(ENQ.DATA)
*------------------------------------------------------------------
*Description: This build is to pass the selection value company code in BRANCH.ID field
*             as we cannot the pass the company code with !ID.COMPANY (It works only for dates like !TODAY)
*------------------------------------------------------------------

    $INCLUDE I_COMMON
    $INCLUDE I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON

    GOSUB PROCESS

    RETURN
*------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------

    LOCATE "BRANCH.ID" IN ENQ.DATA<2,1> SETTING POS1 THEN
        ENQ.DATA<3,POS1> = 'EQ'
        ENQ.DATA<4,POS1> = ID.COMPANY
    END ELSE
        ENQ.DATA<2,POS1> = 'BRANCH.ID'
        ENQ.DATA<3,POS1> = 'EQ'
        ENQ.DATA<4,POS1> = ID.COMPANY
    END

    RETURN
END
