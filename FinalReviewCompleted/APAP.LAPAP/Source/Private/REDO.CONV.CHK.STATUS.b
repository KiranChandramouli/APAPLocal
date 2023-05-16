$PACKAGE APAP.LAPAP
SUBROUTINE REDO.CONV.CHK.STATUS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : APAP
*Program   Name    : REDO.CONV.CHK.STATUS
*----------------------------------------------------------------------------------------------------------------------------
*Description       : Conversion routine to assign the Function to be passed to the Fastpath based on whether it is TT or FT.
*                    throws override and generates the deal slip
*Linked With       : Conversion routine attached to the enquiry NOFILE.REDO.NV.E.AUTHOR
*In  Parameter     : N/A
*Out Parameter     : N/A
*----------------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date            Who                 Reference                     Description
* ------          -----               -------------                 -------------
* 09 Jan 2017     APAP                RTE FIX                       Initial Creation
** 24-04-2023 R22 Auto Conversion no changes
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.FUNDS.TRANSFER

    FN.FT.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FT.NAU = ''
    CALL OPF(FN.FT.NAU,F.FT.NAU)

    Y.TRANS.ID = O.DATA

    IF Y.TRANS.ID[1,2] EQ 'TT' THEN
        O.DATA = 'I'
    END ELSE
        IF Y.TRANS.ID[1,2] EQ 'FT' THEN
            R.FT.ERR = ''
            CALL F.READ(FN.FT.NAU,Y.TRANS.ID,R.FT.NAU,F.FT.NAU,R.FT.ERR)
            IF R.FT.NAU THEN
                Y.TRANS.STATUS = R.FT.NAU<FT.RECORD.STATUS>
                IF Y.TRANS.STATUS EQ 'INAO' THEN
                    O.DATA = 'A'
                END ELSE
                    IF Y.TRANS.STATUS EQ 'INAU' THEN
                        O.DATA = 'I'
                    END
                END
            END
        END
    END

RETURN

END
