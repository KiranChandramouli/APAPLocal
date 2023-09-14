* @ValidationCode : MjozMDg2NjA2NDY6Q3AxMjUyOjE2ODEzNzEzMDA0MDQ6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:05:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.TT.SAME.TILL.TRF
********************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Victor Panchi
*  Program   Name    :REDO.V.TT.SAME.TILL.TRF
***********************************************************************************
*Description:    This is an VALIDATION routine attached to the  version
*                TELLER,REDO.LCY.FCY.TILLTFR. Not allow transfer to the same till
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
***********************************************************************
*DATE              WHO                   REFERENCE         DESCRIPTION
*01-Mar-2012       Victor Panchi         Mantis GR8        INITIAL CREATION
*18-Mar-2012                             Joaquin GR8       Added validation to allow
*                                                          TO TILLS from the same Branch
*                                                          as input teller
*
****************************************************************************
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID
*** Modify by CODE REVIEW
    GOSUB OPEN.FILES
***

    GOSUB PROCESS

RETURN

*****
OPEN.FILES:
*****

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID  = ''
    CALL OPF(FN.TELLER.ID, F.TELLER.ID)

RETURN

********
PROCESS:
********

    IF AF EQ TT.TE.TELLER.ID.1 THEN
        Y.TELLER.ID.1 = COMI
    END ELSE
        Y.TELLER.ID.1 = R.NEW(TT.TE.TELLER.ID.1)
    END

    Y.TELLER.ID.2 = R.NEW(TT.TE.TELLER.ID.2)

    IF Y.TELLER.ID.1 EQ Y.TELLER.ID.2 THEN
        AF    = TT.TE.TELLER.ID.1
        ETEXT = 'TT-TRF.NOT.ALLOWED.SAME.TILL'
        CALL STORE.END.ERROR
    END ELSE
        CALL F.READ(FN.TELLER.ID, Y.TELLER.ID.1, R.TELLER.ID, F.TELLER.ID, TTID.ERR)
        IF R.TELLER.ID<TT.TID.USER> EQ "" AND R.TELLER.ID THEN
            AF = TT.TE.TELLER.ID.1
            ETEXT = 'TT-TILL.NOT.DEFINED'
            CALL STORE.END.ERROR
        END
        IF R.TELLER.ID<TT.TID.CO.CODE> NE ID.COMPANY AND R.TELLER.ID THEN
            AF    = TT.TE.TELLER.ID.1
            ETEXT = 'TT-TILL.NOT.BELONGS.THE.BRANCH'
            CALL STORE.END.ERROR
        END
    END

RETURN
********************************************************
END
*----------------End of Program-----------------------------------------------------------
