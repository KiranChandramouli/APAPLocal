SUBROUTINE REDO.V.TEMP.CHECK.ADMIN.TYPE
*-------------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to throw the error when cheque type is invalid
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
* 06-Jun-2017       Edwin Charles D  R15 Upgrade         Initial Creation
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FT.TT.TRANSACTION

    Y.VAL = COMI  ; Y.D.AF = AF ; Y.D.AV = AV


    VIRTUAL.TAB.ID = 'ADMIN.CHQ.TYPE'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST = VIRTUAL.TAB.ID<2>
    Y.LOOKUP.LIST = CHANGE(Y.LOOKUP.LIST,'_',@FM )

    Y.DESC.LIST = VIRTUAL.TAB.ID<11>
    Y.DESC.LIST = CHANGE(Y.DESC.LIST,'_',@FM)

    FLG = ''
    Y.CNT = DCOUNT(Y.DESC.LIST,@FM)
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.DES = Y.DESC.LIST<FLG>

        LOCATE Y.VAL IN Y.DES<1,1> SETTING POS THEN
            Y.ID.VAL = Y.LOOKUP.LIST<FLG>
            RETURN
        END
        Y.CNT -= 1
    REPEAT

    LOCATE Y.ID.VAL IN Y.LOOKUP.LIST SETTING POS ELSE
        AF = FT.TN.FT.LEGAL.ID
        ETEXT = 'EB-ADMIN.CHQ.NOT.EXIST'
        CALL STORE.END.ERROR

        AF = Y.D.AF
        AV = Y.D.AV
    END

RETURN

END
