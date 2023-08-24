* @ValidationCode : MjoxMTU5NzA0Nzk0OkNwMTI1MjoxNjgxOTA1NjgwNzMwOklUU1M6LTE6LTE6LTk6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -9
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.SEL.DST(SEL.DST)
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :SUDHARSANAN S
*Program Name :REDO.DS.SEL.DST
*Modify :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION :This program is used to get the SELL DESTINATION value from EB.LOOKUP TABLE
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 FM TO @FM
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.USER
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    LOC.REF.FIELD = 'L.TT.FX.SEL.DST'
    LOC.REF.APP = 'TELLER'
    LOC.POS = ''
    CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)

    VAR.SEL.DST = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>

    VIRTUAL.TAB.ID='L.TT.FX.SEL.DST'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
    Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC

    LOCATE VAR.SEL.DST IN Y.LOOKUP.LIST SETTING POS1 THEN
        IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN ;* This is for english user
            SEL.DST=Y.LOOKUP.DESC<POS1,1>
        END
        IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
            SEL.DST=Y.LOOKUP.DESC<POS1,2> ;* This is for spanish user
        END ELSE
            SEL.DST=Y.LOOKUP.DESC<POS1,1>
        END
    END ELSE
        SEL.DST = ''
    END
    SEL.DST=SEL.DST<1,1,1>
    SEL.DST=SEL.DST[1,21]

    SEL.DST=FMT(SEL.DST,'R,#21')
RETURN
END
