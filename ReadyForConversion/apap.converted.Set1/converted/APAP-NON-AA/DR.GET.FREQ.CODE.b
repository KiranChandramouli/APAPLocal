*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.GET.FREQ.CODE(FREQ.CODE,N.FREQ.CODE)
* Incomming -
*      FREQ.CODE - T24 frequency
* Outgoing -
*      FREQ.CODE - Reporting code
*
*-----------------------------------------------
    CHANGE ' ' TO @VM IN FREQ.CODE

    NO.OF.TYP = DCOUNT(FREQ.CODE,@VM)

AA.FREQ:
*---------

    FOR ITYP = 1 TO NO.OF.TYP
        CUR.TYP =  FREQ.CODE<1,ITYP>
        LEN.CUR.TYP = LEN(CUR.TYP)
        LEN.CUR.TYP -= 2

        BEGIN CASE

            CASE CUR.TYP[1] EQ 'Y'
                IF CUR.TYP[2,LEN.CUR.TYP] THEN
                    RET.FREQ = 'A' ; N.FREQ.CODE = 1

                END
            CASE CUR.TYP[1] EQ 'M'
                IF CUR.TYP[2,LEN.CUR.TYP] THEN
                    BEGIN CASE
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 1
                            RET.FREQ = 'M' ; N.FREQ.CODE =  12
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 2
                            RET.FREQ = 'B' ; N.FREQ.CODE =  6
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 3
                            RET.FREQ = 'T' ; N.FREQ.CODE = 4
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 4
                            RET.FREQ = 'C' ; N.FREQ.CODE = 3
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 6
                            RET.FREQ = 'S' ; N.FREQ.CODE = 2
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 12
                            RET.FREQ = 'A' ; N.FREQ.CODE = 1
                    END CASE
                END

        END CASE
    NEXT ITYP
    FREQ.CODE = RET.FREQ
RETURN
