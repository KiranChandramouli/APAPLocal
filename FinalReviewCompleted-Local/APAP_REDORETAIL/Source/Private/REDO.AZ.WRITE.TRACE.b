* @ValidationCode : MjotNjYxODY0MDg0OkNwMTI1MjoxNjgxMjgzOTQ1MTU5OklUU1M6LTE6LTE6MTk5OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:49:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 199
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION               NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
SUBROUTINE REDO.AZ.WRITE.TRACE(Y.RTN.NAME, Y.AZ.ID)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON

    FN.REDO.AZ.TAM.TRACE = 'F.REDO.AZ.TAM.TRACE'
    F.REDO.AZ.TAM.TRACE = ''
    CALL OPF(FN.REDO.AZ.TAM.TRACE, F.REDO.AZ.TAM.TRACE)

    Y.BROWSER = OFS$BROWSER
    Y.VERSION = APPLICATION:PGM.VERSION
    Y.ROUTINE.NAME = Y.RTN.NAME
    Y.FUNCTION = V$FUNCTION
    Y.OFS.SOURCE = OFS$SOURCE.ID
    CALL ALLOCATE.UNIQUE.TIME(Y.TIME)

    Y.ID = Y.AZ.ID:Y.TIME
    Y.USER = OPERATOR
    Y.DATE.TIME = TIMEDATE()
    CHANGE ' ' TO '' IN Y.DATE.TIME
    CHANGE ':' TO '' IN Y.DATE.TIME
    CHANGE '.' TO '' IN Y.DATE.TIME
    Y.ARRAY = Y.VERSION:'*':Y.FUNCTION:'*':ID.NEW:'*':Y.BROWSER:'*':Y.DATE.TIME:'*':Y.USER:'*':Y.ROUTINE.NAME:'*':APPLICATION:'*':Y.OFS.SOURCE
*               1           2            3             4               5              6                7           8                        9

    CALL F.WRITE(FN.REDO.AZ.TAM.TRACE, Y.ID, Y.ARRAY)
RETURN
END
