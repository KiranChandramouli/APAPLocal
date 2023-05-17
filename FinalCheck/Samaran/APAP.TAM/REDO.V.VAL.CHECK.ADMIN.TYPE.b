$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.CHECK.ADMIN.TYPE
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
* 12-APR-2012       S.MARIMUTHU      PACS00189769        Value date added
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    Y.VAL = COMI  ; Y.D.AF = AF ; Y.D.AV = AV


    APPL = 'FUNDS.TRANSFER'
    L.FIELDS = 'L.FT.LEGAL.ID'
    POSS = ''
    CALL MULTI.GET.LOC.REF(APPL,L.FIELDS,POSS)
    Y.MSG.POS = POSS<1,1>

    VIRTUAL.TAB.ID = 'ADMIN.CHQ.TYPE'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST = VIRTUAL.TAB.ID<2>
    Y.LOOKUP.LIST = CHANGE(Y.LOOKUP.LIST,'_',@FM ) ;*R22 AUTO CONVERSION

    Y.DESC.LIST = VIRTUAL.TAB.ID<11>
    Y.DESC.LIST = CHANGE(Y.DESC.LIST,'_',@FM) ;*R22 AUTO CONVERSION

    FLG = ''
    Y.CNT = DCOUNT(Y.DESC.LIST,@FM) ;*R22 AUTO CONVERSION
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
        AF = FT.LOCAL.REF
        AV = Y.MSG.POS
        ETEXT = 'EB-ADMIN.CHQ.NOT.EXIST'
        CALL STORE.END.ERROR

        AF = Y.D.AF
        AV = Y.D.AV
    END

RETURN

END
