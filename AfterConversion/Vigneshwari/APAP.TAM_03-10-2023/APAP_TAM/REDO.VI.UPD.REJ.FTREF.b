* @ValidationCode : MjozMTAxMDU5ODI6Q3AxMjUyOjE2OTYzMzkwOTI4MDM6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Oct 2023 18:48:12
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
SUBROUTINE REDO.VI.UPD.REJ.FTREF
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
** 18-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 18-04-2023 Skanda R22 Manual Conversion - No changes
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


    Y.STLMT.APPL=R.NEW(FT.LOCAL.REF)<1,POS.L.STLMT.APPL>
    Y.STLMT.APPL.ID=R.NEW(FT.LOCAL.REF)<1,POS.L.STLMT.ID>

    IF Y.STLMT.APPL NE '' AND Y.STLMT.APPL.ID NE '' THEN

        FN.APPL='F.':Y.STLMT.APPL
        F.APPL=''
        CALL OPF(FN.APPL,F.APPL)


        GOSUB PROCESS

    END
RETURN

*******
PROCESS:
********


    CALL GET.STANDARD.SELECTION.DETS(Y.STLMT.APPL,R.SS.STLMT.APP)
    Y.FLD.NAME='T24.TRAN.REF'
    LOCATE Y.FLD.NAME IN R.SS.STLMT.APP<SSL.SYS.FIELD.NAME,1> SETTING FLD.POS THEN
        Y.FIELD.POS=R.SS.STLMT.APP<SSL.SYS.FIELD.NO,FLD.POS,1>
    END
    CALL F.READ(FN.APPL,Y.STLMT.APPL.ID,R.APPL,F.APPL,APPL.ERR)
    IF R.APPL THEN
        R.APPL<Y.FIELD.POS>=ID.NEW
        CALL F.WRITE(FN.APPL,Y.STLMT.APPL.ID,R.APPL)
    END
RETURN
END
