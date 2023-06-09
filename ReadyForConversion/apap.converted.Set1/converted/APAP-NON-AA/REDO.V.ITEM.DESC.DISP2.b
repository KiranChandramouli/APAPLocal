SUBROUTINE REDO.V.ITEM.DESC.DISP2
*-----------------------------------------------------------------------------
* Description:
* This routine will be attached to the versions as
* a validation routine
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.ITEM.REQ.DESC
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.H.ITEM.DETAILS
    $INSERT I_F.REDO.H.REASSIGNMENT
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------

    FN.REDO.H.ORDER.DETAILS = 'F.REDO.H.ORDER.DETAILS'
    F.REDO.H.ORDER.DETAILS = ''
    CALL OPF(FN.REDO.H.ORDER.DETAILS,F.REDO.H.ORDER.DETAILS)

    FN.REDO.H.ITEM.DETAILS = 'F.REDO.H.ITEM.DETAILS'
    F.REDO.H.ITEM.DETAILS = ''
    CALL OPF(FN.REDO.H.ITEM.DETAILS,F.REDO.H.ITEM.DETAILS)

    FN.REDO.H.INVENTORY.PARAMETER = 'F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.H.INVENTORY.PARAMETER = ''
    CALL OPF(FN.REDO.H.INVENTORY.PARAMETER,F.REDO.H.INVENTORY.PARAMETER)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------


    Y.DESC = COMI
*    SEL.CMD = 'SELECT ':FN.REDO.H.ITEM.DETAILS:' WITH SUPPLY.CODE EQ "':Y.DESC:'"' :' AND WITH @ID EQ ' : ID.COMPANY
*   CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,ITEM.ERR)

* Y.ITEM.ID = FIELD(SEL.LIST,FM,1)
*  CALL F.READ(FN.REDO.H.ITEM.DETAILS,ID.COMPANY,R.REDO.H.ITEM.DETAILS,F.REDO.H.ITEM.DETAILS,IT.DET.ERR)

* Y.SUPPLY.CODES = R.REDO.H.ITEM.DETAILS<IT.DT.SUPPLY.CODE>
    Y.SUPPLY.CODES = CHANGE(Y.SUPPLY.CODES,@VM,@FM)


*LOCATE Y.DESC IN Y.SUPPLY.CODES SETTING POS THEN
*    Y.SUPPLY.CODE = R.REDO.H.ITEM.DETAILS<IT.DT.DESCRIPTION,POS>
*        R.NEW(IN.PR.ITEM.DESC)<1,AV> = Y.SUPPLY.CODE
*   R.NEW(RE.ASS.DESCRIPTION) = Y.SUPPLY.CODE
*END


    IF Y.DESC THEN
        Y.ID = 'SYSTEM'
        CALL CACHE.READ(FN.REDO.H.ITEM.DETAILS,Y.ID,R.REDO.H.ITEM.DETAILS,IT.DET.ERR)

        Y.SUPPLY.CODES = R.REDO.H.ITEM.DETAILS<IT.DT.SUPPLY.CODE>
        Y.SUPPLY.CODES = CHANGE(Y.SUPPLY.CODES,@VM,@FM)


        LOCATE Y.DESC IN Y.SUPPLY.CODES SETTING POS THEN
            Y.SUPPLY.CODE = R.REDO.H.ITEM.DETAILS<IT.DT.DESCRIPTION,POS>
            R.NEW(RE.ASS.DESCRIPTION) = Y.SUPPLY.CODE
        END

    END ELSE
        R.NEW(RE.ASS.DESCRIPTION) = ''
    END

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
END
*-------------------------------------------------------------------------
