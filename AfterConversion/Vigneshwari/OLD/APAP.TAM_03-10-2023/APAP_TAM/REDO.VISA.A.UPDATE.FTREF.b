* @ValidationCode : MjotMTAxMDEwODI5MDpDcDEyNTI6MTY5NjMzOTU2NDc5ODp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Oct 2023 18:56:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.VISA.A.UPDATE.FTREF
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VI.VISA.APPROVE
***********************************************************************************
*Description: This routine is to update the FT reference number of settlement raised
*             in respective tables. It should be attached to all the FT Versions
*             in fields FT.VERSION of REDO.APAP.H.PARAMETET as AUTH routine.
*
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*03.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
*11.04.2023  Conversion Tool   R22            Auto Conversion     - VM TO @VM, = TO EQ
*11.04.2023  Shanmugapriya M   R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.ATM.REVERSAL


    GOSUB GET.LOCAL.REF
    GOSUB INIT
RETURN
*----------------------------------------------------------------------
GET.LOCAL.REF:
*----------------------------------------------------------------------
    LOC.REF.APPLICATION="FUNDS.TRANSFER"
    LOC.REF.FIELDS='L.STLMT.ID':@VM:'L.STLMT.APPL':@VM:'AT.UNIQUE.ID'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.STLMT.ID=LOC.REF.POS<1,1>
    POS.L.STLMT.APPL=LOC.REF.POS<1,2>
    POS.AT.UNIQUE.ID=LOC.REF.POS<1,3>


RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.ATM.REVERSAL ='F.ATM.REVERSAL'
    F.ATM.REVERSAL  =''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)
    Y.STLMT.APPL=R.NEW(FT.LOCAL.REF)<1,POS.L.STLMT.APPL>
    Y.STLMT.APPL.ID=R.NEW(FT.LOCAL.REF)<1,POS.L.STLMT.ID>


    IF Y.STLMT.APPL NE '' AND Y.STLMT.APPL.ID NE '' THEN

        FN.APPL='F.':Y.STLMT.APPL
        F.APPL=''
        CALL OPF(FN.APPL,F.APPL)

*FN.STANDARD.SELECTION='F.STANDARD.SELECTION'
*F.STANDARD.SELECTION=''
*CALL OPF(FN.STANDARD.SELECTION,F.STANDARD.SELECTION)

        GOSUB PROCESS

    END ELSE

        GOSUB UPDATE.ATM.REV
    END

RETURN

*******
PROCESS:
********


*CALL F.READ(FN.STANDARD.SELECTION,Y.STLMT.APPL,R.SS.STLMT.APP,F.STANDARD.SELECTION,SS.ERR)
    CALL GET.STANDARD.SELECTION.DETS(Y.STLMT.APPL,R.SS.STLMT.APP)
    Y.FLD.NAME='T24.TRAN.REF'
    LOCATE Y.FLD.NAME IN R.SS.STLMT.APP<SSL.SYS.FIELD.NAME,1> SETTING FLD.POS THEN
        Y.FIELD.POS=R.SS.STLMT.APP<SSL.SYS.FIELD.NO,FLD.POS,1>
    END
    CALL F.READ(FN.APPL,Y.STLMT.APPL.ID,R.APPL,F.APPL,APPL.ERR)
    R.APPL<Y.FIELD.POS>=ID.NEW
    CALL F.WRITE(FN.APPL,Y.STLMT.APPL.ID,R.APPL)

    LOCATE 'TRANSACTION.CODE' IN R.SS.STLMT.APP<SSL.SYS.FIELD.NAME,1> SETTING FLD.POS.TC THEN
        Y.FLD.TC.POS=R.SS.STLMT.APP<SSL.SYS.FIELD.NO,FLD.POS.TC,1>
    END
    LOCATE 'USAGE.CODE' IN R.SS.STLMT.APP<SSL.SYS.FIELD.NAME,1> SETTING FLD.POS.US THEN
        Y.USAGE.CODE.POS=R.SS.STLMT.APP<SSL.SYS.FIELD.NO,FLD.POS.US,1>

    END
    Y.TC.CODE=R.APPL<Y.FLD.TC.POS>
    IF (Y.TC.CODE EQ 05 OR Y.TC.CODE EQ 06 OR Y.TC.CODE EQ 07 OR Y.TC.CODE EQ 26 OR Y.TC.CODE EQ 25 OR Y.TC.CODE EQ 27) AND R.APPL<Y.USAGE.CODE.POS> EQ 1 THEN

        GOSUB UPDATE.ATM.REV

    END ELSE

        IF Y.STLMT.APPL EQ 'REDO.ATH.SETTLMENT' OR Y.STLMT.APPL EQ 'REDO.VISA.STLMT.05TO37' THEN     ;** R22 Auto conversion - = TO EQ
            GOSUB UPDATE.ATM.REV
        END

    END

RETURN

*-------------------------------------------------------------
UPDATE.ATM.REV:
*-------------------------------------------------------------
    IF R.NEW(FT.LOCAL.REF)<1,POS.AT.UNIQUE.ID> NE '' THEN
        Y.ATM.REV.ID=R.NEW(FT.LOCAL.REF)<1,POS.AT.UNIQUE.ID>
        CALL F.READ(FN.ATM.REVERSAL,Y.ATM.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERR)
        IF R.ATM.REVERSAL NE '' THEN
            R.ATM.REVERSAL<AT.REV.TXN.REF> = ID.NEW
            CALL F.WRITE(FN.ATM.REVERSAL,Y.ATM.REV.ID,R.ATM.REVERSAL)
        END
    END

RETURN

END
