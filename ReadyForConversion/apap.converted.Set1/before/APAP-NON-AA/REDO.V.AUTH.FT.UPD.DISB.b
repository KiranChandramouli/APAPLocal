*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.AUTH.FT.UPD.DISB
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is an Auth routine attached to version.control FUNDS.TRANSFER,DSB
*
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
*Modification History:-
* Date                 Who                Reference                     Description
*------------------------------------------------------------------------------------
* 09/06/2017       Edwin Charles D       R15 Upgrade                Initial Creation
*------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.DISB.CHAIN

    GOSUB INIT
    GOSUB PROCESS

    RETURN
******
INIT:
******
*Initialize all the variables

    FN.REDO.DISB.CHAIN = 'F.REDO.DISB.CHAIN'
    F.REDO.DISB.CHAIN = ''
    CALL OPF(FN.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN)

    LREF.APP = 'FUNDS.TRANSFER'
    LREF.FIELDS = 'L.INITIAL.ID'

    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    POS.L.INITIAL.ID       = LREF.POS<1,1>

    RETURN
***********
PROCESS:
***********

    Y.INITIAL.ID = ''; Y.TEMP.FT.ID = '' ; R.REDO.DISB.CHAIN = ''
    Y.INITIAL.ID   = R.NEW(FT.LOCAL.REF)<1,POS.L.INITIAL.ID>
    Y.TEMP.FT.ID   = R.NEW(FT.CREDIT.THEIR.REF)
    CALL F.READ(FN.REDO.DISB.CHAIN,Y.INITIAL.ID,R.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN,CHAIN.ERR)
    IF R.REDO.DISB.CHAIN THEN
        TEMP.FT.ID.ARR = R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF>
        LOCATE Y.TEMP.FT.ID IN TEMP.FT.ID.ARR<1,1> SETTING FT.POS THEN
            R.REDO.DISB.CHAIN<DS.CH.TRANSACTION.ID, FT.POS> = ID.NEW
            R.REDO.DISB.CHAIN<DS.CH.VERSION, FT.POS>        = APPLICATION:PGM.VERSION
        END

        CALL F.WRITE(FN.REDO.DISB.CHAIN,Y.INITIAL.ID,R.REDO.DISB.CHAIN)
    END
    RETURN
******************************************************************************************************
END
